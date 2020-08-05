class Pius < Formula
  include Language::Python::Virtualenv

  desc "PGP individual UID signer"
  homepage "https://www.phildev.net/pius/"
  url "https://github.com/jaymzh/pius/archive/v3.0.0.tar.gz"
  sha256 "3454ade5540687caf6d8b271dd18eb773a57ab4f5503fc71b4769cc3c5f2b572"
  revision 1
  head "https://github.com/jaymzh/pius.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e94572eadd5e0adeda1fb16cb05f44afd486b9ba3667c0139ec5588e7f947775" => :catalina
    sha256 "499e1c8b31c8c1930cc8b6a7d187854302890ba51585fdba92515f0f014069ff" => :mojave
    sha256 "d0b7237e06c967976ff74ccdf110afe9712cda1b2e0dd870f43599eb337d2eb9" => :high_sierra
  end

  depends_on "gnupg"
  depends_on "python@3.8"

  def install
    # Replace hardcoded gpg path (WONTFIX)
    inreplace "libpius/constants.py", %r{/usr/bin/gpg2?}, "/usr/bin/env gpg"
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      The path to gpg is hardcoded in pius as `/usr/bin/env gpg`.
      You can specify a different path by editing ~/.pius:
        gpg-path=/path/to/gpg
    EOS
  end

  test do
    system bin/"pius", "-T"
  end
end
