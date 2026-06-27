class Pius < Formula
  include Language::Python::Virtualenv

  desc "PGP individual UID signer"
  homepage "https://github.com/jaymzh/pius"
  url "https://github.com/jaymzh/pius/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "3454ade5540687caf6d8b271dd18eb773a57ab4f5503fc71b4769cc3c5f2b572"
  license "GPL-2.0-only"
  revision 3
  head "https://github.com/jaymzh/pius.git", branch: "main"

  bottle do
    rebuild 7
    sha256 cellar: :any_skip_relocation, all: "4140e7427663db5e6c5d33d1b1589afe1d257b135c2874c15ac3d6b9aee3d743"
  end

  depends_on "gnupg"
  depends_on "python@3.14"

  def install
    # Replace hardcoded gpg path (WONTFIX)
    inreplace "libpius/constants.py", %r{/usr/bin/gpg2?}, "/usr/bin/env gpg"

    virtualenv_install_with_resources
  end

  def caveats
    <<~TEXT
      The path to gpg is hardcoded in pius as `/usr/bin/env gpg`.
      You can specify a different path by editing ~/.pius:
        gpg-path=/path/to/gpg
    TEXT
  end

  test do
    output = shell_output("#{bin}/pius -T")
    assert_match "Welcome to PIUS, the PGP Individual UID Signer", output

    assert_match version.to_s, shell_output("#{bin}/pius --version")
  end
end
