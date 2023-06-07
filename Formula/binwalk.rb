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
    sha256 cellar: :any,                 arm64_ventura:  "4f7bf49bcdc180a94d923859aaae9bb975531e3f66c0946fa0e8560d76e9705d"
    sha256 cellar: :any,                 arm64_monterey: "50bc5ac7368e8f0423f374afe062b6e9f36a20a6a288991b129340185a67e6c9"
    sha256 cellar: :any,                 arm64_big_sur:  "d5e7979beefcf75ed418a517ec05ddabccc02712790eac38f3b82c118abd3aac"
    sha256 cellar: :any,                 ventura:        "097c35817c67fb96ab78e91be7f316f931e356ab8b06d27d340e567d25769dc7"
    sha256 cellar: :any,                 monterey:       "3835d5d50f13e1bbf7e960b5bd6c354ece0ba0cda79599c956b9d860e668896c"
    sha256 cellar: :any,                 big_sur:        "db580e80796365ee95126a20ba213c360f5bd170c6cdf68d7598860979229566"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b2728143c492690a2d7193a20bbfa8dc57c1b16f0709995a29aefc9b1270379"
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
