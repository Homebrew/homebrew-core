class EasyRsa < Formula
  desc "CLI utility to build and manage a PKI CA"
  homepage "https://github.com/OpenVPN/easy-rsa"
  url "https://github.com/OpenVPN/easy-rsa/releases/download/v3.2.6/EasyRSA-3.2.6.tgz"
  sha256 "c2572990ce91112eef8d1b8e4a3b58790da95b68501785c621f69121dfbd22d7"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/OpenVPN/easy-rsa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "91e0b6e75447c6760e9a176815e0cfbbf84c1add06819fd310b7095c1ab9b2b2"
  end

  depends_on "openssl@4"

  def install
    inreplace "easyrsa" do |s|
      s.gsub! "'/etc/easy-rsa'", "'#{pkgetc}'"
      s.gsub! "'/usr/local/share/easy-rsa'", "'#{opt_pkgshare}'"
    end

    libexec.install "easyrsa"
    (bin/"easyrsa").write_env_script libexec/"easyrsa",
      EASYRSA:         pkgetc,
      EASYRSA_OPENSSL: Formula["openssl@4"].opt_bin/"openssl",
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
