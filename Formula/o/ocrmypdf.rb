class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://ocrmypdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/cd/67/524ae8f93dd60f59b10798f09286efe6670d1b277d4add78a1916a94003e/ocrmypdf-16.10.1.tar.gz"
  sha256 "9f32059fc97e25931aaa0a8a4027b8c9faca7d9e1183089f32e0cba5631449f1"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bbd2d06d0499eaaa54a81faf386aaeb75531ed6dffe9545101c12bd2635b5072"
    sha256 cellar: :any,                 arm64_sonoma:  "a0392d121b861fb3991467007ee4b272a1530088782548025ad7788f0b3b557e"
    sha256 cellar: :any,                 arm64_ventura: "c37f857a1cfc986775d4a12186141f20a27a91591e12671eb452227fbcdc7dc6"
    sha256 cellar: :any,                 sonoma:        "5a4ad00c5b89de17316f4fe20f5dfcd83c07d103f75e758aa5d471841467bcf5"
    sha256 cellar: :any,                 ventura:       "0297fd55d99762e9a327eec657f103febf16f7bb9738e86c1ae3a7e019808c53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bbc89c60fcabc7d54118972c2dba1d51f12f7b8b7b9d53047b02f5ade333fa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a6ed079684bb461316fe25c27015841fd11750645a3bd25dcbf94a0022a4528"
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
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
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
    url "https://files.pythonhosted.org/packages/c2/62/c7402ffe11d43e88dbab6b7255f16743f8b9cbb3e7d3405f95a677a98c47/img2pdf-0.6.0.tar.gz"
    sha256 "85a89b8abdeef9ef033508aed0d9f1e84fd6d0130e864e2c523f948ec45365e1"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/76/3d/14e82fc7c8fb1b7761f7e748fd47e2ec8276d137b6acfe5a4bb73853e08f/lxml-5.4.0.tar.gz"
    sha256 "d12832e1dbea4be280b22fd0ea7c9b87f0d8fc51ba06e92dc62d52f804f78ebd"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
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
    url "https://files.pythonhosted.org/packages/a8/27/1a99ce4cfce829bb91040f82a53f33b33fec4e070d2b9c1b45f6796cd8dc/pdfminer_six-20250416.tar.gz"
    sha256 "30956a85f9d0add806a4e460ed0d67c2b6a48b53323c7ac87de23174596d3acd"
  end

  resource "pi-heif" do
    url "https://files.pythonhosted.org/packages/4f/90/ff6dcd9aa3b725f7eba9d70e1a12003effe45aa5bd438e3a20d14818f846/pi_heif-0.22.0.tar.gz"
    sha256 "489ddda3c9fed948715a9c8642c6ee24c3b438a7fbf85b3a8f097d632d7082a8"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/9d/eb/4756ba366b5b243a1b5711e02993ea932d45d7e2d750bf01eb0029dc443e/pikepdf-9.7.0.tar.gz"
    sha256 "ab54895a246768a2660cafe48052dbf5425c76f6f04e0f53b911df6cfd7e1c95"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/96/2d/02d4312c973c6050a18b314a5ad0b3210edb65a906f868e31c111dede4a6/pluggy-1.5.0.tar.gz"
    sha256 "2cffa88e94fdc978c4c574f15f9e59b7f4201d439195c3715ca9e2486f1d0cf1"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a1/53/830aa4c3066a8ab0ae9a9955976fb770fe9c6102117c8ec4ab3ea62d89e8/rich-14.0.0.tar.gz"
    sha256 "82f1bc23a6a21ebca4ae0c45af9bdbc492ed20231dcb63f297d6d1021a9d5725"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/c3/fc/e91cc220803d7bc4db93fb02facd8461c37364151b8494762cc88b0fbcef/wrapt-1.17.2.tar.gz"
    sha256 "41388e9d4d1522446fe79d3213196bd9e3b301a336965b9e27ca2788ebd122f3"
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
