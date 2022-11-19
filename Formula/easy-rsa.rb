class EasyRsa < Formula
  desc "CLI utility to build and manage a PKI CA"
  homepage "https://github.com/OpenVPN/easy-rsa"
  url "https://github.com/OpenVPN/easy-rsa/archive/v3.1.1.tar.gz"
  sha256 "35032fa0a07288e87504703fd6546f310c4e2692ccc23b94cb66acdd664badd5"
  license "GPL-2.0-only"
  head "https://github.com/OpenVPN/easy-rsa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a041662e1abcfba6bddc70ac6f4416d4a84e75f10c5fa7b104fbeab8e842b81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a041662e1abcfba6bddc70ac6f4416d4a84e75f10c5fa7b104fbeab8e842b81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a041662e1abcfba6bddc70ac6f4416d4a84e75f10c5fa7b104fbeab8e842b81"
    sha256 cellar: :any_skip_relocation, ventura:        "d18291c09bc93374aefda8f1a8311cbca7fcdd325f2803b0fff6863624c95df6"
    sha256 cellar: :any_skip_relocation, monterey:       "d18291c09bc93374aefda8f1a8311cbca7fcdd325f2803b0fff6863624c95df6"
    sha256 cellar: :any_skip_relocation, big_sur:        "d18291c09bc93374aefda8f1a8311cbca7fcdd325f2803b0fff6863624c95df6"
    sha256 cellar: :any_skip_relocation, catalina:       "d18291c09bc93374aefda8f1a8311cbca7fcdd325f2803b0fff6863624c95df6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a041662e1abcfba6bddc70ac6f4416d4a84e75f10c5fa7b104fbeab8e842b81"
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
