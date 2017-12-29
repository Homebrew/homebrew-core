class Pius < Formula
  include Language::Python::Virtualenv

  desc "PGP individual UID signer"
  homepage "https://www.phildev.net/pius/"
  url "https://github.com/jaymzh/pius/archive/v2.2.4.tar.gz"
  sha256 "876763c351ba8538d0c614c31f1873b5e821425927631139c83378532215516c"
  revision 1
  head "https://github.com/jaymzh/pius.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "40a07225e28d22b1860a9eaddd5dc4557172360125d9f172e87065daa1f8b195" => :high_sierra
    sha256 "248f6562eaa6abca6500f5ec93488b0f983b7839c8d2060c4a208432783e5d66" => :sierra
    sha256 "a55f1aa243dd35d5332fae94fc9604bb2306e534b00b1f11362b2fdd1188df0d" => :el_capitan
    sha256 "15444762e1364bdbfc4fce49279c8c016f4a6060e4a7efb38fb5e8e26d56e69b" => :yosemite
  end

  depends_on "gnupg"

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
