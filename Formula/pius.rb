class Pius < Formula
  include Language::Python::Virtualenv

  desc "PGP individual UID signer"
  homepage "https://www.phildev.net/pius/"
  url "https://github.com/jaymzh/pius/archive/v2.2.6.tar.gz"
  sha256 "88727d2377db6d57e9832c0d923d42edd835ba1b14f1e455f90b024eba291921"
  head "https://github.com/jaymzh/pius.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e61fb984be02aed9fb987cbeb18e87171223c63c19c50e686b088ce69834e74b" => :high_sierra
    sha256 "6ad7b984c2f5d885a3ba4e37e8bb4e1e1062be4f5afbcb4a629a108d69ad210f" => :sierra
    sha256 "365c3d3909644e880995951241b2725037274135b5a2d1063989c7f5409acd48" => :el_capitan
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
