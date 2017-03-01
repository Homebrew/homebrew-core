class Pius < Formula
  include Language::Python::Virtualenv

  desc "PGP individual UID signer"
  homepage "https://www.phildev.net/pius/"
  url "https://github.com/jaymzh/pius/archive/v2.2.4.tar.gz"
  sha256 "876763c351ba8538d0c614c31f1873b5e821425927631139c83378532215516c"
  head "https://github.com/jaymzh/pius.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2778646308e77a969894ca4f5d0e0d89ebae865b81c6a2f2dec63e4633d7d6b5" => :sierra
    sha256 "7cc107c732cef3855444ac1e60e435538a45ceeebc657b0bb74af4c6ee173534" => :el_capitan
    sha256 "2d428378ed6f08f04715b24c9145a1cf68fa49e8f8492fdff0bb532718c5310c" => :yosemite
  end

  depends_on :gpg => :run

  def install
    # Replace hardcoded gpg path (WONTFIX)
    inreplace "libpius/constants.py", %r{/usr/bin/gpg2?}, "/usr/bin/env gpg"
    virtualenv_install_with_resources
  end

  def caveats; <<-EOS.undent
    The path to gpg is hardcoded in pius as `/usr/bin/env gpg`.
    You can specify a different path by editing ~/.pius:
      gpg-path=/path/to/gpg
    EOS
  end

  test do
    system bin/"pius", "-T"
  end
end
