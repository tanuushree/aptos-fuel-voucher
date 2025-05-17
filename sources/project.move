module HelloMessage::FuelVoucherSystem {
    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a fuel voucher
    struct FuelVoucher has key, store {
        amount: u64,     // Amount of fuel credits
        is_redeemed: bool,
    }

    /// Function to create a fuel voucher under the issuers account
    public fun create_voucher(issuer: &signer, amount: u64) {
        assert!(amount > 0, 0);
        let voucher = FuelVoucher {
            amount,
            is_redeemed: false,
        };
        move_to(issuer, voucher);
    }

    /// Function for transporter to redeem the voucher
    public fun redeem_voucher(transporter: &signer, issuer_address: address) acquires FuelVoucher {
        let voucher = borrow_global_mut<FuelVoucher>(issuer_address);
        assert!(!voucher.is_redeemed, 1);

        let payment = coin::withdraw<AptosCoin>(transporter, voucher.amount);
        coin::deposit<AptosCoin>(issuer_address, payment);

        voucher.is_redeemed = true;
    }
}
