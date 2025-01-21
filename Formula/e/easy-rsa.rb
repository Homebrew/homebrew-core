class EasyRsa < Formula
  desc "CLI utility to build and manage a PKI CA"
  homepage "https://github.com/OpenVPN/easy-rsa"
  url "https://github.com/OpenVPN/easy-rsa/releases/download/v3.2.1/EasyRSA-3.2.1.tgz"
  sha256 "ec0fdca46c07afef341e0e0eeb2bf0cfe74a11322b77163e5d764d28cb4eec89"
  license "GPL-2.0-only"
  head "https://github.com/OpenVPN/easy-rsa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3057967081df2d2d15bf9547dc7d7a25019fccd91340ecb5f801c1f6c9c71d5a"
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
      EASYRSA_PKI:     "${EASYRSA_PKI:-#{etc}/pki}"

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
