class EasyRsa < Formula
  desc "CLI utility to build and manage a PKI CA"
  homepage "https://github.com/OpenVPN/easy-rsa"
  url "https://github.com/OpenVPN/easy-rsa/archive/v3.1.7.tar.gz"
  sha256 "438206426324e6d34380d09da265b9ea1e2e2c0b301865dfef1ee89cb394602a"
  license "GPL-2.0-only"
  head "https://github.com/OpenVPN/easy-rsa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3ac00723ab628127ed9ba4204754e4bf4e5ad49cb851a27d032e79ad437a630"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3ac00723ab628127ed9ba4204754e4bf4e5ad49cb851a27d032e79ad437a630"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3ac00723ab628127ed9ba4204754e4bf4e5ad49cb851a27d032e79ad437a630"
    sha256 cellar: :any_skip_relocation, sonoma:         "db0099d1a5f5540baf921b0b5231400fd28acfbfc41ee2f591d78a7cf9908e76"
    sha256 cellar: :any_skip_relocation, ventura:        "db0099d1a5f5540baf921b0b5231400fd28acfbfc41ee2f591d78a7cf9908e76"
    sha256 cellar: :any_skip_relocation, monterey:       "db0099d1a5f5540baf921b0b5231400fd28acfbfc41ee2f591d78a7cf9908e76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3ac00723ab628127ed9ba4204754e4bf4e5ad49cb851a27d032e79ad437a630"
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
