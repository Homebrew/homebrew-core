class EasyRsa < Formula
  desc "CLI utility to build and manage a PKI CA"
  homepage "https://github.com/OpenVPN/easy-rsa"
  url "https://github.com/OpenVPN/easy-rsa/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "0d714529486f7bdc312dac5e2082b8715ddf58e41bb17e35e8c20606604c5335"
  license "GPL-2.0-only"
  head "https://github.com/OpenVPN/easy-rsa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5efd48b9124a25e409090f477abd19764aa5fa9c88c4e267e2e6466fdb5aaaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "376a1e6c33f1c9220982516223a430725527066c1aa96498bbc20bef53e8063e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a97a074340e6adb1af4c8d31136a8d666f1c70a1a1c350f4c6722370ad86568"
    sha256 cellar: :any_skip_relocation, sonoma:         "a813c5e2dd29c13362011203e37417dae5d977f89bb82d2dbf541a55fd9aea90"
    sha256 cellar: :any_skip_relocation, ventura:        "a99d0ee6a849da660390dd73893d81c26a83d8e7e734072c463b3c315ce5afaa"
    sha256 cellar: :any_skip_relocation, monterey:       "8d1b5c8dc4bffbe8c60d5b871d941e411b618de54bb9c30e925867aa4beea900"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f1b45cfc4e2dc2ef886d86e1ba8b2eeae91ef2239f60cdb3af4caa2acd35015"
  end

  depends_on "openssl@3"

  def install
    inreplace "easyrsa3/easyrsa", "'/etc/easy-rsa'", "'#{pkgetc}'"
    libexec.install "easyrsa3/easyrsa"
    (bin/"easyrsa").write_env_script libexec/"easyrsa",
      EASYRSA:         pkgetc,
      EASYRSA_OPENSSL: Formula["openssl@3"].opt_bin/"openssl",
      EASYRSA_PKI:     "${EASYRSA_PKI:-#{etc}/pki}"

    pkgetc.install %w[
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
        #{pkgetc}/vars.example
    EOS
  end

  test do
    ENV["EASYRSA_PKI"] = testpath/"pki"
    assert_match "'init-pki' complete; you may now create a CA or requests.",
      shell_output("#{bin}/easyrsa init-pki")
  end
end
