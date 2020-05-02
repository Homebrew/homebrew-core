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
    sha256 "e9ba4374fb3a68bd4b0c9dab7fb3bdc7591fb742af79859f83f6df69ca774913" => :catalina
    sha256 "b90078fc6aeda02b140a97c534ec19d587465e4f8425ae492fb2988ac28b7f05" => :mojave
    sha256 "a157ec03fd571b4cf8e732e42dd4a48c5a0c5117a0164fe49261ed445a367415" => :high_sierra
    sha256 "a29676721817a3f58d8f03683f7d3ed55780b476f3fc6d4f6de7156422423e76" => :sierra
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
