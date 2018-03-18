class Pius < Formula
  include Language::Python::Virtualenv

  desc "PGP individual UID signer"
  homepage "https://www.phildev.net/pius/"
  url "https://github.com/jaymzh/pius/archive/v2.2.5.tar.gz"
  sha256 "a42bb13971ff1d2a3bea4436d2c6dfaed6748eeaf2ad4bf2318805ccd18f9891"
  head "https://github.com/jaymzh/pius.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c04e58f291f4185c98d6cde4708c9b3f8c08563ba4d4555fcb32809b5c75916" => :high_sierra
    sha256 "2fdc3d5b4fce9b55ab0c3b468ffd70ecb2e0f656a80609fb3178848082f83b27" => :sierra
    sha256 "e0345dc516c520f5c2c14b1f06b7f147375ac91676991a47e523de0af4ce2e64" => :el_capitan
  end

  depends_on "gnupg"

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  def install
    # Replace hardcoded gpg path (WONTFIX)
    inreplace "libpius/constants.py", %r{/usr/bin/gpg2?}, "/usr/bin/env gpg"
    virtualenv_install_with_resources
  end

  def caveats; <<~EOS
    The path to gpg is hardcoded in pius as `/usr/bin/env gpg`.
    You can specify a different path by editing ~/.pius:
      gpg-path=/path/to/gpg
    EOS
  end

  test do
    system bin/"pius", "-T"
  end
end
