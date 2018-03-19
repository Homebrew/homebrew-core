class Pius < Formula
  include Language::Python::Virtualenv

  desc "PGP individual UID signer"
  homepage "https://www.phildev.net/pius/"
  url "https://github.com/jaymzh/pius/archive/v2.2.6.tar.gz"
  sha256 "88727d2377db6d57e9832c0d923d42edd835ba1b14f1e455f90b024eba291921"
  head "https://github.com/jaymzh/pius.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a35dcffc50bb72dd015b41c072ce59450af3f5be7d80c1ab147c5d073f5fef82" => :high_sierra
    sha256 "9d0f1df1935a72f6e0375272f0f6bd1bf0e3bef7e823592c7db48337359a3ca4" => :sierra
    sha256 "41ec87c9e2e8d2b480cf7041066cbf9fcb24bb885f9794c3c44a1b0e314d38d3" => :el_capitan
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
