class Pius < Formula
  include Language::Python::Virtualenv

  desc "PGP individual UID signer"
  homepage "https://www.phildev.net/pius/"
  url "https://github.com/jaymzh/pius/archive/v2.2.6.tar.gz"
  sha256 "88727d2377db6d57e9832c0d923d42edd835ba1b14f1e455f90b024eba291921"
  revision 1
  head "https://github.com/jaymzh/pius.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d879b8fa36572f39451238f0de4b83f243d74370e6cf5d0c908d1f758591adb8" => :mojave
    sha256 "e113e0d49fd040b5c5a338e40dbbe541158f8d7fbd8de3d73a0d9f5b717969cc" => :high_sierra
    sha256 "104cc7287e9a26087ac5060a79365cdf1a24cd69cd693e942bfa4a4d0b18e300" => :sierra
  end

  depends_on "gnupg"
  depends_on "python"

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
