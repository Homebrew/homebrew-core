class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://github.com/jbarlow83/OCRmyPDF"
  url "https://files.pythonhosted.org/packages/c3/e1/bab4844da8f43aec32d89d9813c245dc4d6887612d1b7f9c4d17f8204a8c/ocrmypdf-13.1.1.tar.gz"
  sha256 "562bd3c7c2e9d4f3c8b7ef5c4e04b2de8a4c2941e05aea31ad091a3f3d1be7ac"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0406167963bba7125b5f443443b3a6d327e95698fd0d1f64b11fd75512ae0600"
    sha256 cellar: :any,                 arm64_big_sur:  "98eb29edd13db59b2a6e3ca8f24ab0215118d506a3171dc0802066f1d28684a1"
    sha256 cellar: :any,                 monterey:       "968c944cecdfd0138b0a18db7a26703ae297330adf506bce40e620b370ba03b8"
    sha256 cellar: :any,                 big_sur:        "8dec2f13e78f3890a41311322d46a6e57f0a1fbbfc81295fe0138f42c8b43f31"
    sha256 cellar: :any,                 catalina:       "10090687e24bf91c8f5cd4c12731ac38dd62eb876d8c21f1106a9cb70cc3d5b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cabfffb5a97453b4ba1e3856035b59601c633d39efd5082a3fe4ba73d79e0ff"
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
    url "https://files.pythonhosted.org/packages/60/06/d9109aba62c0b42466195e5b9b30dded26621a675b73998218070d8cc637/cryptography-36.0.0.tar.gz"
    sha256 "52f769ecb4ef39865719aedc67b4b7eae167bafa48dbc2a26dd36fa56460507f"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/cc/3f/2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43/humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "img2pdf" do
    url "https://files.pythonhosted.org/packages/3c/b2/0483a18ae81c99ceccffb7482b26262f01eec8dee00bb63c0546ef27789e/img2pdf-0.4.3.tar.gz"
    sha256 "8e51c5043efa95d751481b516071a006f87c2a4059961a9ac43ec238915de09f"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/fe/4c/a4dbb4e389f75e69dbfb623462dfe0d0e652107a95481d40084830d29b37/lxml-4.6.4.tar.gz"
    sha256 "daf9bd1fee31f1c7a5928b3e1059e09a8d683ea58fb3ffc773b6c88cb8d1399c"
  end

  resource "pdfminer.six" do
    url "https://files.pythonhosted.org/packages/ac/0a/b01677bb31bd79756f05ff3e052ad369ac0ebb2e64b47fc6d6bad290d981/pdfminer.six-20211012.tar.gz"
    sha256 "0351f17d362ee2d48b158be52bcde6576d96460efd038a3e89a043fba6d634d7"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/49/07/b6a6c8c5c45e27ddff1b559693a535411bf5e871212a8e4ccdd36d517634/pikepdf-4.2.0.tar.gz"
    sha256 "9a91564193f2c01a55aef4c3b97764b2cb59443034b62a95620b12eb265c647e"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/a1/16/db2d7de3474b6e37cbb9c008965ee63835bba517e22cdb8c35b5116b5ce1/pluggy-1.0.0.tar.gz"
    sha256 "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "reportlab" do
    url "https://files.pythonhosted.org/packages/f9/67/3b6363e2b1eda86b1c32296a45dd089b5198c14606830029968c18e39080/reportlab-3.6.3.tar.gz"
    sha256 "be4f05230eb17b9c9c61a180ab0c89c30112da2823c77807a2a5ddba19365865"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/e3/c1/b3e42d5b659ca598508e2a9ef315d5eef0a970f874ef9d3b38d4578765bd/tqdm-4.62.3.tar.gz"
    sha256 "d359de7217506c9851b7869f3708d8ee53ed70a1b8edbba4dbcb47442592920d"
  end

  def install
    # Fix "ld: file not found: /usr/lib/system/libsystem_darwin.dylib" for lxml
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

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
