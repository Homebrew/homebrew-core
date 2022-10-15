class EasyRsa < Formula
  desc "CLI utility to build and manage a PKI CA"
  homepage "https://github.com/OpenVPN/easy-rsa"
  url "https://github.com/OpenVPN/easy-rsa/archive/v3.1.1.tar.gz"
  sha256 "35032fa0a07288e87504703fd6546f310c4e2692ccc23b94cb66acdd664badd5"
  license "GPL-2.0-only"
  head "https://github.com/OpenVPN/easy-rsa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "437812094c85963e49adfb49b8533da608f9bec1a0c64181935f828c012c89bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "437812094c85963e49adfb49b8533da608f9bec1a0c64181935f828c012c89bb"
    sha256 cellar: :any_skip_relocation, monterey:       "09a549d3ff88f28ee642dcf3ba74905be122769882ce16256f133d48e8e0d5ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "09a549d3ff88f28ee642dcf3ba74905be122769882ce16256f133d48e8e0d5ca"
    sha256 cellar: :any_skip_relocation, catalina:       "09a549d3ff88f28ee642dcf3ba74905be122769882ce16256f133d48e8e0d5ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "437812094c85963e49adfb49b8533da608f9bec1a0c64181935f828c012c89bb"
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
