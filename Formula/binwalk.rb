class Binwalk < Formula
  include Language::Python::Virtualenv

  desc "Searches a binary image for embedded files and executable code"
  homepage "https://github.com/ReFirmLabs/binwalk"
  url "https://github.com/ReFirmLabs/binwalk/archive/v2.3.1.tar.gz"
  sha256 "7ec9d8fcb8686f4060d37e1096669e3ed8ce1194c91ad80199622448bcc01b19"
  license "MIT"
  head "https://github.com/ReFirmLabs/binwalk.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "de845e209f61f7d53daec264962ce1aeb2fb72b5385ea6b8c9ac2188d0427bff"
    sha256 cellar: :any, big_sur:       "1d408cfd054c7f7e7d1035fae12f1ed22951c99ae2037e12d26a274e97ef3335"
    sha256 cellar: :any, catalina:      "81908a0bc129aade679fcb65b0455ce349288e4ed4239bf48ef68a4fde363f8f"
    sha256 cellar: :any, mojave:        "6d71751e65e4c7f368018a13f38fc7ae56db3174e567e353073aead6bfd6fb76"
  end

  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "numpy"
  depends_on "p7zip"
  depends_on "python@3.9"
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

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/ed/46/e298a50dde405e1c202e316fa6a3015ff9288423661d7ea5e8f22f589071/wheel-0.36.2.tar.gz"
    sha256 "e11eefd162658ea59a60a0f6c7d493a7190ea4b9a85e335b33489d9f17e0245e"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/90/55/399ab9f2e171047d28933ae4b686d9382d17e6c09a01bead4a6f6b5038f4/kiwisolver-1.3.1.tar.gz"
    sha256 "950a199911a8d94683a6b10321f9345d5a3a8433ec58b217ace979e18f16e248"
  end

  resource "matplotlib" do
    url "https://files.pythonhosted.org/packages/22/d4/e7ca532e68a9357742604e1e4ae35d9c09a4a810de39a9d80402bd12f50f/matplotlib-3.3.4.tar.gz"
    sha256 "3e477db76c22929e4c6876c44f88d790aacdf3c3f8f3a90cb1975c0bf37825b0"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    touch "binwalk.test"
    system "#{bin}/binwalk", "binwalk.test"
  end
end
