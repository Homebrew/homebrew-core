class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://ocrmypdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/13/11/dad06efcf749d77dfcebac0bdec7980f57a9d58a38f2fdc1e0e9ade84ec0/ocrmypdf-16.11.1.tar.gz"
  sha256 "838ab69e0ee0f04feea0d5861a17badecab6d3beaed0e29a97058eadda58cbb1"
  license "MPL-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a32c59501243b694a0d977cb7ab2d14441eb2421f6798f028739598252bbe2c4"
    sha256 cellar: :any,                 arm64_sequoia: "4cab7988dca44c96aeaf3ed831fb7d2a5570b0b99ed73e300c3f73e242b47bcf"
    sha256 cellar: :any,                 arm64_sonoma:  "819cd2badcdc3499fd1b80f8e845cd881b3ffccc7eceb38958240c8d3c7b7699"
    sha256 cellar: :any,                 sonoma:        "3a5e4bbff114d160113ac30c9b71f22489bfd9db6b4a7d96106b0ede119f16e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "461c03e530bf8227121c2f7ec7685799a1cbb6871d86abdcf914ec27a22c6c92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c09930fb451794608c09e3e683950effc80e3a3f6988c5640c47ebd046b0b494"
  end

  depends_on "cmake" => :build # for pikepdf
  depends_on "pkgconf" => :build
  depends_on "cryptography" => :no_linkage
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "img2pdf"
  depends_on "jbig2enc"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "pillow" => :no_linkage
  depends_on "pngquant"
  depends_on "pybind11"
  depends_on "python@3.14"
  depends_on "qpdf"
  depends_on "tesseract"
  depends_on "unpaper"

  uses_from_macos "libffi"
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: %w[cryptography pillow]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/98/97/06afe62762c9a8a86af0cfb7bfdab22a43ad17138b07af5b1a58442690a2/deprecated-1.2.18.tar.gz"
    sha256 "422b6f6d859da6f2ef57857761bfb392480502a64c3028ca9bbe86085d72115d"
  end

  resource "deprecation" do
    url "https://files.pythonhosted.org/packages/5a/d3/8ae2869247df154b64c1884d7346d412fed0c49df84db635aab2d1c40e62/deprecation-2.1.0.tar.gz"
    sha256 "72b3bde64e5d778694b0cf68178aed03d15e15477116add3fb773e581f9518ff"
  end

  resource "img2pdf" do
    url "https://files.pythonhosted.org/packages/82/c3/023387e00682dc1b46bd719ec19c4c9206dc8eb182dfd02bc62c5b9320a2/img2pdf-0.6.1.tar.gz"
    sha256 "306e279eb832bc159d7d6294b697a9fbd11b4be1f799b14b3b2174fb506af289"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pdfminer-six" do
    url "https://files.pythonhosted.org/packages/78/46/5223d613ac4963e1f7c07b2660fe0e9e770102ec6bda8c038400113fb215/pdfminer_six-20250506.tar.gz"
    sha256 "b03cc8df09cf3c7aba8246deae52e0bca7ebb112a38895b5e1d4f5dd2b8ca2e7"
  end

  resource "pi-heif" do
    url "https://files.pythonhosted.org/packages/bf/7b/7c7b2aeb4995906725f13b885884d5b22e4f2d55028e8941555d2789e5e7/pi_heif-1.1.1.tar.gz"
    sha256 "42ece7c3b40569f295fd4d2b10f38d1cd5012ca548446a2ca33895f0d6900c4f"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/f5/4c/62b37a3ee301c245be6ad269ca771c2c5298bf049366e1094cfdf80d850c/pikepdf-9.11.0.tar.gz"
    sha256 "5ad6bffba08849c21eee273ba0b6fcd4b6a9cff81bcbca6988f87a765ba62163"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/8f/aeb76c5b46e273670962298c23e7ddde79916cb74db802131d49a85e4b7d/wrapt-1.17.3.tar.gz"
    sha256 "f66eb08feaa410fe4eebd17f2a2c8e2e46d3476e9f8c783daa8e09e0faa666d0"
  end

  def install
    virtualenv_install_with_resources

    bash_completion.install "misc/completion/ocrmypdf.bash" => "ocrmypdf"
    fish_completion.install "misc/completion/ocrmypdf.fish"
  end

  test do
    system bin/"ocrmypdf", "-f", "-q", "--deskew",
                           test_fixtures("test.pdf"), "ocr.pdf"
    assert_path_exists testpath/"ocr.pdf"
  end
end
