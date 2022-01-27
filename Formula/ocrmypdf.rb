class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://github.com/jbarlow83/OCRmyPDF"
  url "https://files.pythonhosted.org/packages/61/42/3d09ddbd44aa72bed204a2cca32c79c0521078ba5cf27ac0024058d98e88/ocrmypdf-13.3.0.tar.gz"
  sha256 "20682c9603e6264dc33e3e4f4cb13bec661f8c670f9f688371b87c5fd2fc95e1"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c9a470f0854e4e041777a1b16a326e37c804453b50577a58eeb04052668b6719"
    sha256 cellar: :any,                 arm64_big_sur:  "6f30a51e9e07f29ff8cf280c1100df86ab8c6308bb8db078b0ef27b4774720d9"
    sha256 cellar: :any,                 monterey:       "a541cddbb963a4a8ecf77c8293f3acec522db038d4bfba9e29f5e1a5669444e2"
    sha256 cellar: :any,                 big_sur:        "e0f56e47fb2d47b512fbe77cc198458c5733b15e39337b73855b3dc3c4becd0a"
    sha256 cellar: :any,                 catalina:       "a883aafbe4dc402517d41113bf74cb694b3f965396d969fcef3d0ef60c5cb378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d63bf865bfdc14eec2c978a2e854bdf8aebe0c5846b738a4173830152c016b77"
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
    url "https://files.pythonhosted.org/packages/f9/4b/1cf8e281f7ae4046a59e5e39dd7471d46db9f61bb564fddbff9084c4334f/cryptography-36.0.1.tar.gz"
    sha256 "53e5c1dc3d7a953de055d77bef2ff607ceef7a2aac0353b5d630ab67f7423638"
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
    url "https://files.pythonhosted.org/packages/84/74/4a97db45381316cd6e7d4b1eb707d7f60d38cb2985b5dfd7251a340404da/lxml-4.7.1.tar.gz"
    sha256 "a1613838aa6b89af4ba10a0f3a972836128801ed008078f8c1244e65958f1b24"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pdfminer.six" do
    url "https://files.pythonhosted.org/packages/ac/0a/b01677bb31bd79756f05ff3e052ad369ac0ebb2e64b47fc6d6bad290d981/pdfminer.six-20211012.tar.gz"
    sha256 "0351f17d362ee2d48b158be52bcde6576d96460efd038a3e89a043fba6d634d7"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/b4/a5/6487992141abc6133a1c59ca7389d761177f156b00364b79199d1c3307c0/pikepdf-4.4.1.tar.gz"
    sha256 "c25d4c7673f9588d1f98bca498db98ba675070dc89ffffe50b3b124d4a005df9"
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
    url "https://files.pythonhosted.org/packages/d9/18/8215e8c2d16148c2c9b04e7329bdb43ae33819cdd1f73a79cd6e264bad4f/reportlab-3.6.6.tar.gz"
    sha256 "dd1cdb62dc123f5859ca514eb639f70660bdc818c95fb0ee2370a175a0e20ce4"
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
