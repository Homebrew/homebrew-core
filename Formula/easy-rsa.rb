class EasyRsa < Formula
  desc "CLI utility to build and manage a PKI CA"
  homepage "https://github.com/OpenVPN/easy-rsa"
  url "https://github.com/OpenVPN/easy-rsa/archive/v3.0.8.tar.gz"
  sha256 "fd6b67d867c3b8afd53efa2ca015477f6658a02323e1799432083472ac0dd200"
  license "GPL-2.0-only"
  head "https://github.com/OpenVPN/easy-rsa.git"

  depends_on "openssl@1.1"

  def install
    libexec.install "easyrsa3/easyrsa"
    (bin/"easyrsa").write_env_script libexec/"easyrsa",
      EASYRSA:         etc/name,
      EASYRSA_OPENSSL: Formula["openssl@1.1"].bin/"openssl",
      EASYRSA_PKI:     "${EASYRSA_PKI:-#{etc}/pki}"

    (etc/name).install %w[
      easyrsa3/openssl-easyrsa.cnf
      easyrsa3/x509-types
      easyrsa3/vars.example
    ]

    doc.install %w[
      ChangeLog
      COPYING.md
      KNOWN_ISSUES
      README.md
      README.quickstart.md
    ]

    doc.install Dir["doc/*"]
  end

  def caveats
    <<~EOS
      By default, keys will be created in:
        #{etc}/pki

      The configuration may be modified by editing and renaming:
        #{etc}/#{name}/vars.example
    EOS
  end

  test do
    ENV["EASYRSA_PKI"] = testpath/"pki"
    assert_match "init-pki complete", shell_output("easyrsa init-pki")
  end
end
