class EasyRsa < Formula
  desc "CLI utility to build and manage a PKI CA."
  homepage "https://github.com/OpenVPN/easy-rsa"
  url "https://github.com/OpenVPN/easy-rsa/archive/3.0.1.tar.gz"
  sha256 "a1fff75a27ea7da3f37fbfed715633f55b9ca25f5b14cac38e525c5c995e68ae"

  depends_on "openssl"

  def install
    # We don't use the installer from the package, as it doesn't organize things
    # well for brew install. It puts the binary in the prefix root, and defaults
    # to a pki path that will be overwritten on installation.
    inreplace "easyrsa3/easyrsa" do |s|
      s.gsub! /set_var EASYRSA		"\$PWD"/,
              "set_var EASYRSA		\"#{libexec}\""
      s.gsub! /set_var EASYRSA_PKI	.*/,
              "set_var EASYRSA_PKI	\"#{etc}/pki\""
      openssl_path = Formula["openssl"].opt_bin/"openssl"
      s.gsub! /set_var EASYRSA_OPENSSL	openssl/,
              "set_var EASYRSA_OPENSSL	\"#{openssl_path}\""
    end
    bin.install "easyrsa3/easyrsa"
    libexec.install "easyrsa3/openssl-1.0.cnf", "easyrsa3/x509-types"
  end

  test do
    # Create a stub PKI directory in the test sandbox.
    ENV["EASYRSA_PKI"] = testpath/"pki"
    system bin/"easyrsa", "--help"
    system bin/"easyrsa", "init-pki"
  end
end
