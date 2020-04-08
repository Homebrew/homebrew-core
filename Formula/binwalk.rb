class Binwalk < Formula
  include Language::Python::Virtualenv

  desc "Searches a binary image for embedded files and executable code"
  homepage "https://github.com/ReFirmLabs/binwalk"
  url "https://github.com/ReFirmLabs/binwalk/archive/v2.2.0.tar.gz"
  sha256 "f5495f0e4c5575023d593f7c087c367675df6aeb7f4d9a2966e49763924daa27"
  revision 1
  head "https://github.com/ReFirmLabs/binwalk.git"

  bottle do
    cellar :any
    sha256 "e95a1061cccebe8b26ade0344cfec88d987f0344c0ef3ef0dae1ca9d7e2304ec" => :catalina
    sha256 "aade25dafcf47d5a9b4e8c51f8e5aba3fe3c9e09cd2a592aec68a7e685741ee0" => :mojave
    sha256 "ddf7030e8ff4e1f5a2aed178b1ccff13f3e6e5428bd23ab63679fbaeeb89ac80" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "freetype"
  depends_on "gcc" # for gfortran
  depends_on "libpng"
  depends_on "p7zip"
  depends_on "python@3.8"
  depends_on "ssdeep"
  depends_on "xz"

  resource "capstone" do
    url "https://files.pythonhosted.org/packages/2a/a2/026cc921a6ac7e4fcd0c2ba740edce4c37c56af63a79e570bebaf3bd7c50/capstone-4.0.1.tar.gz"
    sha256 "5857accc0de1e769b0ec0a0ca985715bfa96e5a66a2ebb3aaed43a8e3655377f"
  end

  resource "Cycler" do
    url "https://files.pythonhosted.org/packages/c2/4b/137dea450d6e1e3d474e1d873cd1d4f7d3beed7e0dc973b06e8e10d32488/cycler-0.10.0.tar.gz"
    sha256 "cd7b2d1018258d7247a71425e9f26463dfb444d411c39569972f4ce586b0c9d8"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/62/b8/db619d97819afb52a3ff5ff6ad3f7de408cc83a8ec2dfb31a1731c0a97c2/kiwisolver-1.2.0.tar.gz"
    sha256 "247800260cd38160c362d211dcaf4ed0f7816afb5efe56544748b21d6ad6d17f"
  end

  resource "matplotlib" do
    url "https://files.pythonhosted.org/packages/4a/30/eb8e7dd8e3609f05c6920fa82f189302c832e5a0f6667aa96f952056bc0c/matplotlib-3.2.1.tar.gz"
    sha256 "ffe2f9cdcea1086fc414e82f42271ecf1976700b8edd16ca9d376189c6d93aee"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/84/1e/ff467ac56bfeaea51d4a2e72d315c1fe440b20192fea7e460f0f248acac8/numpy-1.18.2.zip"
    sha256 "e7894793e6e8540dbeac77c87b489e331947813511108ae097f1715c018b8f3d"
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
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    touch "binwalk.test"
    system "#{bin}/binwalk", "binwalk.test"
  end
end
