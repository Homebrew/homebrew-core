class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://ocrmypdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/07/cf/d207aea8442a8e5a63b16faae89af2b9e3474d8d5925a5ea8c4f10f73fa9/ocrmypdf-16.10.0.tar.gz"
  sha256 "d5b907a7b92951f1f3617f0f5ca002d866143d94fd168546a70e51756bf6412e"
  license "MPL-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1188e0366cb4c5b43be5f16b247257b9096b73eb9a3335736f1c26a66da142d1"
    sha256 cellar: :any,                 arm64_sonoma:  "1985541922050ae776a9e64e76792a4babe548cf3f3cc46c458fe22364004d88"
    sha256 cellar: :any,                 arm64_ventura: "bb0092ad31c407c37a6a660b6263c5b489166efd8de5aa65f0a7026d46f4aa97"
    sha256 cellar: :any,                 sonoma:        "734b8231f66bdbd5d2fdbeccd7545a1345cdd4c3bcd4afd6686f7a48749ba862"
    sha256 cellar: :any,                 ventura:       "2f2275dfaa08ceaac5932e9deec3d84f335ad31d3d3c9435c9f17c36e1543a6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "451440d6945f64a2245a5c8d295a460497643b70100e040b7375e962ae1e5615"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af7782bb4b312000ce9fbb4863a37f286c44061010a86a7a81825771a29c1275"
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
    url "https://files.pythonhosted.org/packages/ef/f6/c15ca8e5646e937c148e147244817672cf920b56ac0bf2cc1512ae674be8/lxml-5.3.1.tar.gz"
    sha256 "106b7b5d2977b339f1e97efe2778e2ab20e99994cbb0ec5e55771ed0795920c8"
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
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pdfminer-six" do
    url "https://files.pythonhosted.org/packages/e3/37/63cb918ffa21412dd5d54e32e190e69bfc340f3d6aa072ad740bec9386bb/pdfminer.six-20240706.tar.gz"
    sha256 "c631a46d5da957a9ffe4460c5dce21e8431dabb615fee5f9f4400603a58d95a6"
  end

  resource "pi-heif" do
    url "https://files.pythonhosted.org/packages/f5/12/e87b1a7e5b353f885b646ee9c966be74b7db0ae9d68abc712411487353d7/pi_heif-0.21.0.tar.gz"
    sha256 "4902cdb84e75505e1d9abdd5aff1e6dcfebe569ec825162d68a4a399a43689a4"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/1c/2c/0707248e2bdfe148c53c43ea1a7fce730eab9ae8bbe65470720f5a7ddd25/pikepdf-9.5.2.tar.gz"
    sha256 "190b3bb4891a7a154315f505d7dcd557ef21e8130cea8b78eb9646f8d67072ed"
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
    url "https://files.pythonhosted.org/packages/ab/3a/0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bc/rich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
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
