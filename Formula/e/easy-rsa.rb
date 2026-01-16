class EasyRsa < Formula
  desc "CLI utility to build and manage a PKI CA"
  homepage "https://github.com/OpenVPN/easy-rsa"
  url "https://github.com/OpenVPN/easy-rsa/releases/download/v3.2.5/EasyRSA-3.2.5.tgz"
  sha256 "662ee3b453155aeb1dff7096ec052cd83176c460cfa82ac130ef8568ec4df490"
  license "GPL-2.0-only"
  head "https://github.com/OpenVPN/easy-rsa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9e5f7f681e8b28d23fa4f883443566caeb27ec57d32902f935b9d3a6cece4059"
  end

  depends_on "openssl@3"

  def install
    inreplace "easyrsa" do |s|
      s.gsub! "'/etc/easy-rsa'", "'#{pkgetc}'"
      s.gsub! "'/usr/local/share/easy-rsa'", "'#{opt_pkgshare}'"
    end

    libexec.install "easyrsa"
    (bin/"easyrsa").write_env_script libexec/"easyrsa",
      EASYRSA:         pkgetc,
      EASYRSA_OPENSSL: Formula["openssl@3"].opt_bin/"openssl",
      EASYRSA_PKI:     "${EASYRSA_PKI:-#{etc}/easy-rsa/pki}"

    pkgetc.install %w[
      openssl-easyrsa.cnf
      x509-types
      vars.example
    ]

    doc.install %w[
      ChangeLog
      COPYING.md
      README.md
      README.quickstart.md
    ]

    doc.install Dir["doc/*"]
  end

  def caveats
    <<~EOS
      By default, keys will be created in:
        #{etc}/easy-rsa/pki

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
