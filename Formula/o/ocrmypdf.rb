class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://ocrmypdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/44/af/947d6abb0cb41f99971a7a4bd33684d3cee20c9e32c8f9dc90e8c5dcf21c/ocrmypdf-16.11.0.tar.gz"
  sha256 "d89077e503238dac35c6e565925edc8d98b71e5289853c02cacbc1d0901f1be7"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1f8ed40c4076df4a99cf3aa28c1fa158345b06b06647c9dc2751d1a60f15a8ca"
    sha256 cellar: :any,                 arm64_sequoia: "6fe07bd9701379b4fb9d75d3a4d42fd9486851561e4807c320e204fa43044217"
    sha256 cellar: :any,                 arm64_sonoma:  "096f35bea748f515505a84b82b82cd2adecb59c288e8c56161a7e7029341b3d7"
    sha256 cellar: :any,                 sonoma:        "4fe0189730f40d80926f74c6209add8e78e096f3aad672c78ba1ab0c68038762"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3e6085422c0b5eca7762b83d043decb3a100e40f05241ce0d68883e581c92df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e50998a6a7b4449c7423ed830fc5025e2609e5f01ca465c86d788fdd00e1b9bb"
  end

  depends_on "pkgconf" => :build
  depends_on "cryptography"
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "img2pdf"
  depends_on "jbig2enc"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "pillow"
  depends_on "pngquant"
  depends_on "pybind11"
  depends_on "python@3.13"
  depends_on "qpdf"
  depends_on "tesseract"
  depends_on "unpaper"

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
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
    url "https://files.pythonhosted.org/packages/8f/bd/f9d01fd4132d81c6f43ab01983caea69ec9614b913c290a26738431a015d/lxml-6.0.1.tar.gz"
    sha256 "2b3a882ebf27dd026df3801a87cf49ff791336e0f94b0fad195db77e01240690"
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
    url "https://files.pythonhosted.org/packages/a1/3c/15d70bac37e50bd03ca2cdf7f7237d237c6f4e3e6d6cefdcc95b53dd708e/pi_heif-1.1.0.tar.gz"
    sha256 "bac501008a000f2c560086d82e785e3ca2fc688b24b66c1d7dae537ef2fd6a6e"
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
    url "https://files.pythonhosted.org/packages/fe/75/af448d8e52bf1d8fa6a9d089ca6c07ff4453d86c65c145d0a300bb073b9b/rich-14.1.0.tar.gz"
    sha256 "e497a48b844b0320d45007cdebfeaeed8db2a4f4bcf49f15e455cfc4af11eaa8"
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
