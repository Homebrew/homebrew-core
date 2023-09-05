class EasyRsa < Formula
  desc "CLI utility to build and manage a PKI CA"
  homepage "https://github.com/OpenVPN/easy-rsa"
  url "https://github.com/OpenVPN/easy-rsa/archive/v3.1.6.tar.gz"
  sha256 "82958fc66ba3825dd78113c3b3283858303d9973caff434989a4a235d47a319d"
  license "GPL-2.0-only"
  head "https://github.com/OpenVPN/easy-rsa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42813aefc0517c80c7b7efd846eede30d816cf05ee47fd49b1e6c5dfd72f8cc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42813aefc0517c80c7b7efd846eede30d816cf05ee47fd49b1e6c5dfd72f8cc8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42813aefc0517c80c7b7efd846eede30d816cf05ee47fd49b1e6c5dfd72f8cc8"
    sha256 cellar: :any_skip_relocation, ventura:        "d1cd86ad4f56473e7295ca8eb15655bd781ba7c4353d6f242a9ec57dd3960f96"
    sha256 cellar: :any_skip_relocation, monterey:       "d1cd86ad4f56473e7295ca8eb15655bd781ba7c4353d6f242a9ec57dd3960f96"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1cd86ad4f56473e7295ca8eb15655bd781ba7c4353d6f242a9ec57dd3960f96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42813aefc0517c80c7b7efd846eede30d816cf05ee47fd49b1e6c5dfd72f8cc8"
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
