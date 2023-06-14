class EasyRsa < Formula
  desc "CLI utility to build and manage a PKI CA"
  homepage "https://github.com/OpenVPN/easy-rsa"
  url "https://github.com/OpenVPN/easy-rsa/archive/v3.1.5.tar.gz"
  sha256 "9292046ceb1267cdebd3ea770c6842b5298365c167b1fae75f388e11c6bf9093"
  license "GPL-2.0-only"
  head "https://github.com/OpenVPN/easy-rsa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a638a78e738e3fc633eb849a1bbd326f1495acb4b740be083092572625372004"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a638a78e738e3fc633eb849a1bbd326f1495acb4b740be083092572625372004"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a638a78e738e3fc633eb849a1bbd326f1495acb4b740be083092572625372004"
    sha256 cellar: :any_skip_relocation, ventura:        "86f6e2ec6216a7c7e56f47f09360dcb1c887f0dae3cd6c9dfb003dc5ce5f4e19"
    sha256 cellar: :any_skip_relocation, monterey:       "86f6e2ec6216a7c7e56f47f09360dcb1c887f0dae3cd6c9dfb003dc5ce5f4e19"
    sha256 cellar: :any_skip_relocation, big_sur:        "86f6e2ec6216a7c7e56f47f09360dcb1c887f0dae3cd6c9dfb003dc5ce5f4e19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a638a78e738e3fc633eb849a1bbd326f1495acb4b740be083092572625372004"
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
