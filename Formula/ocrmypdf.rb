class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://github.com/jbarlow83/OCRmyPDF"
  url "https://files.pythonhosted.org/packages/24/09/7b6dc26872916431f5689102d4c415308bc118a1a6ada61420396519f74c/ocrmypdf-13.4.2.tar.gz"
  sha256 "d52410bc38cf5b66da27668e38c66ac41fd3136457c1ec388b311f0a78ee213c"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "61378525ea9a271369ca3c43bff43e78208fc7ef7e08d7f4a4368aa680fe07e4"
    sha256 cellar: :any,                 arm64_big_sur:  "1d38c66dab9eecf554770ed1afa39c0ce46a05938af629b35e49f1bee35db506"
    sha256 cellar: :any,                 monterey:       "67a708729cfbd9f570d6e5e7d18885156a99ada4f60515831f6848674f1d2145"
    sha256 cellar: :any,                 big_sur:        "a655cfb2626dd5be5e9fab4c9eb5939e11b3fc9ae863bb98e82c0e6d2c64f807"
    sha256 cellar: :any,                 catalina:       "b5e69d148046118dc1f8d7ddb9dce24dab9ea9e78878656a1c1439ad4d01dcae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae380629701aa7ab29035d0f89b5b48e4205ff5daa225c78871501305cad1ac3"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ghostscript"
  depends_on "jbig2enc"
  depends_on "libffi"
  depends_on "libpng"
  depends_on "pillow"
  depends_on "pngquant"
  depends_on "pybind11"
  depends_on "python@3.9"
  depends_on "qpdf"
  depends_on "tesseract"
  depends_on "unpaper"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "coloredlogs" do
    url "https://files.pythonhosted.org/packages/cc/c7/eed8f27100517e8c0e6b923d5f0845d0cb99763da6fdee00478f91db7325/coloredlogs-15.0.1.tar.gz"
    sha256 "7c991aa71a4577af2f82600d8f8f3a89f936baeaf9b50a9c197da014e5bf16b0"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/10/a7/51953e73828deef2b58ba1604de9167843ee9cd4185d8aaffcb45dd1932d/cryptography-36.0.2.tar.gz"
    sha256 "70f8f4f7bb2ac9f340655cbac89d68c527af5bb4387522a8413e841e3e6628c9"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/cc/3f/2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43/humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "img2pdf" do
    url "https://files.pythonhosted.org/packages/95/b5/f933f482a811fb9a7b3707f60e28f2925fed84726e5a6283ba07fdd54f49/img2pdf-0.4.4.tar.gz"
    sha256 "8ec898a9646523fd3862b154f3f47cd52609c24cc3e2dc1fb5f0168f0cbe793c"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/3b/94/e2b1b3bad91d15526c7e38918795883cee18b93f6785ea8ecf13f8ffa01e/lxml-4.8.0.tar.gz"
    sha256 "f63f62fc60e6228a4ca9abae28228f35e1bd3ce675013d1dfb828688d50c6e23"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pdfminer.six" do
    url "https://files.pythonhosted.org/packages/a0/e2/cf4782c86fbe487da3c9aed105878a4af7fbd64c7e3f85403722e6a82dae/pdfminer.six-20220319.tar.gz"
    sha256 "eff2ce0abeaa4df94dc3461f70eab104487c7b4a2b3c7e9fd0aeec6c5f44d6a6"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/b5/b7/b1ae6cb14af447e3b7401d03a035192d97e1ef42838c717b10b32d7d52a0/pikepdf-5.1.1.tar.gz"
    sha256 "710535c679ab0d7b8249f72247832773e7a9a121dfbe9cad7f6465bd9bb45fae"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/a1/16/db2d7de3474b6e37cbb9c008965ee63835bba517e22cdb8c35b5116b5ce1/pluggy-1.0.0.tar.gz"
    sha256 "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/d6/60/9bed18f43275b34198eb9720d4c1238c68b3755620d20df0afd89424d32b/pyparsing-3.0.7.tar.gz"
    sha256 "18ee9022775d270c55187733956460083db60b37d0d0fb357445f3094eed3eea"
  end

  resource "reportlab" do
    url "https://files.pythonhosted.org/packages/50/c7/f80ab0ff9c7f7dc0b537fad0ee929ea5e56091b3f72de8e04ab3e02086b6/reportlab-3.6.8.tar.gz"
    sha256 "dc7657fcb0bc3e485c3c869a44dddb52d711356a01a456664b7bef827222c982"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/98/2a/838de32e09bd511cf69fe4ae13ffc748ac143449bfc24bb3fd172d53a84f/tqdm-4.64.0.tar.gz"
    sha256 "40be55d30e200777a307a7585aee69e4eabb46b4ec6a4b4a5f2d9f11e7d5408d"
  end

  def install
    virtualenv_install_with_resources

    bash_completion.install "misc/completion/ocrmypdf.bash" => "ocrmypdf"
    fish_completion.install "misc/completion/ocrmypdf.fish"
  end

  test do
    system "#{bin}/ocrmypdf", "-f", "-q", "--deskew",
                              test_fixtures("test.pdf"), "ocr.pdf"
    assert_predicate testpath/"ocr.pdf", :exist?
  end
end
