class Binwalk < Formula
  include Language::Python::Virtualenv

  desc "Searches a binary image for embedded files and executable code"
  homepage "https://github.com/ReFirmLabs/binwalk"
  url "https://github.com/ReFirmLabs/binwalk/archive/v2.3.3.tar.gz"
  sha256 "7e32b94dc77632b51d18732b5456e2a3ef85e4521d7d4a54410e36f93859501f"
  license "MIT"
  revision 1
  head "https://github.com/ReFirmLabs/binwalk.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4d174cfab2b8ac93175083b9023d380d3550df4ba6fb2aece19ef21de95f282f"
    sha256 cellar: :any,                 arm64_big_sur:  "32a0ba9dda4f2c7ca35e1b0315d93c213de11f6748905529354f7c91d0b5dd1d"
    sha256 cellar: :any,                 monterey:       "bc7bb74e6c67d99191e84594a5fdece82b96eff032eab43ebcae10d039dc6270"
    sha256 cellar: :any,                 big_sur:        "07fcdc50883c29ee5c8159b00dc09b17c2c6e64258fe04692fb3b2b8d0c19dc0"
    sha256 cellar: :any,                 catalina:       "b30e0aa8c9716d63b086113ce9d37e0b7c4e2d9f1afa1d870bf694880fa84de6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd1090b38fc5a2b031f419bd96b34798ee13bf085649b584f304868703085fb4"
  end

  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "numpy"
  depends_on "p7zip"
  depends_on "pillow"
  depends_on "python@3.10"
  depends_on "six"
  depends_on "ssdeep"
  depends_on "xz"

  resource "capstone" do
    url "https://files.pythonhosted.org/packages/f2/ae/21dbb3ccc30d5cc9e8cdd8febfbf5d16d93b8c10e595280d2aa4631a0d1f/capstone-4.0.2.tar.gz"
    sha256 "2842913092c9b69fd903744bc1b87488e1451625460baac173056e1808ec1c66"
  end

  resource "Cycler" do
    url "https://files.pythonhosted.org/packages/c2/4b/137dea450d6e1e3d474e1d873cd1d4f7d3beed7e0dc973b06e8e10d32488/cycler-0.10.0.tar.gz"
    sha256 "cd7b2d1018258d7247a71425e9f26463dfb444d411c39569972f4ce586b0c9d8"
  end

  resource "gnupg" do
    url "https://files.pythonhosted.org/packages/96/6c/21f99b450d2f0821ff35343b9a7843b71e98de35192454606435c72991a8/gnupg-2.3.1.tar.gz"
    sha256 "8db5a05c369dbc231dab4c98515ce828f2dffdc14f1534441a6c59b71c6d2031"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/8e/87/259fde8cf07d06677f0a749cb157d079ebd00d40fe52faaab1a882a66159/kiwisolver-1.3.2.tar.gz"
    sha256 "fc4453705b81d03568d5b808ad8f09c77c47534f6ac2e72e733f9ca4714aa75c"
  end

  resource "matplotlib" do
    url "https://files.pythonhosted.org/packages/21/37/197e68df384ff694f78d687a49ad39f96c67b8d75718bc61503e1676b617/matplotlib-3.4.3.tar.gz"
    sha256 "fc4f526dfdb31c9bd6b8ca06bf9fab663ca12f3ec9cdf4496fb44bc680140318"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/88/7f/740b99ffb8173ba9d20eb890cc05187677df90219649645aca7e44eb8ff4/pycryptodome-3.10.1.tar.gz"
    sha256 "3e2e3a06580c5f190df843cdb90ea28d61099cf4924334d5297a995de68e4673"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    touch "binwalk.test"
    system "#{bin}/binwalk", "binwalk.test"
  end
end
