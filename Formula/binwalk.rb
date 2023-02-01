class Binwalk < Formula
  include Language::Python::Virtualenv

  desc "Searches a binary image for embedded files and executable code"
  homepage "https://github.com/ReFirmLabs/binwalk"
  url "https://github.com/ReFirmLabs/binwalk/archive/v2.3.4.tar.gz"
  sha256 "60416bfec2390cec76742ce942737df3e6585c933c2467932f59c21e002ba7a9"
  license "MIT"
  head "https://github.com/ReFirmLabs/binwalk.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "790b8e8314d7f644a7404d73bde374abc4dbbc4b50e6b87d0ae0887fbc571493"
    sha256 cellar: :any,                 arm64_monterey: "235c50f581a73d80e729446c0358419e0c5fa3d5f172502e374087ff0599f146"
    sha256 cellar: :any,                 arm64_big_sur:  "307c12b610778f36e7ab1305b7e413af6506e91b5655ee2f85463618d580b3ae"
    sha256 cellar: :any,                 ventura:        "942ee604c48c17e1685bf802eb31fbdb11e91cee162e5632f86720adaeff7fd6"
    sha256 cellar: :any,                 monterey:       "68a5e01815f4b7fb6b6518c159c3349eda5131f7e2ec0a0ff466c9010f6e56f8"
    sha256 cellar: :any,                 big_sur:        "0310a3066ffbb65165f11f14205eabd6a0473e624d61d73ad5d6311ea140b4a1"
    sha256 cellar: :any,                 catalina:       "b2dadab228a96a7973b20342b383c733f65aeea0032ee7c8cf07bfcefd02a8a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "958c19b5bab3a65688396412441a14f8c00d191f540dcd2dcef6941b5dbfb2a1"
  end

  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "numpy"
  depends_on "p7zip"
  depends_on "pillow"
  depends_on "python@3.11"
  depends_on "six"
  depends_on "ssdeep"
  depends_on "xz"

  resource "capstone" do
    url "https://files.pythonhosted.org/packages/f2/ae/21dbb3ccc30d5cc9e8cdd8febfbf5d16d93b8c10e595280d2aa4631a0d1f/capstone-4.0.2.tar.gz"
    sha256 "2842913092c9b69fd903744bc1b87488e1451625460baac173056e1808ec1c66"
  end

  resource "gnupg" do
    url "https://files.pythonhosted.org/packages/96/6c/21f99b450d2f0821ff35343b9a7843b71e98de35192454606435c72991a8/gnupg-2.3.1.tar.gz"
    sha256 "8db5a05c369dbc231dab4c98515ce828f2dffdc14f1534441a6c59b71c6d2031"
  end

  resource "matplotlib" do
    url "https://files.pythonhosted.org/packages/23/6d/2917ed23b17a8c4d1d59974a574cae0a365c392ba8820c8824b03a02f376/matplotlib-3.6.3.tar.gz"
    sha256 "1f4d69707b1677560cd952544ee4962f68ff07952fb9069ff8c12b56353cb8c9"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/b8/2e/cf9cfd1ae6429381d3d9c14c8df79d91ae163929972f245a76058ea9d37d/pycryptodome-3.17.tar.gz"
    sha256 "bce2e2d8e82fcf972005652371a3e8731956a0c1fbb719cc897943b3695ad91b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    touch "binwalk.test"
    system "#{bin}/binwalk", "binwalk.test"
  end
end
