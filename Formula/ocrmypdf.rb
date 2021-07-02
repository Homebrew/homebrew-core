class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://github.com/jbarlow83/OCRmyPDF"
  url "https://files.pythonhosted.org/packages/41/ec/e4159c465406e723eb7f66108344cd49429515469a4c339f143c4d34613f/ocrmypdf-12.2.0.tar.gz"
  sha256 "00e5e39d18553c76a26767f02ed228c0f2476836bb81b2fdea71cb0fbfcdc57d"
  license "MPL-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "310585ce97a515f7ee36d32d28e1c48c252d5fb360d004a208ec020a02de2d02"
    sha256 cellar: :any, big_sur:       "b5c054682392409c6c5bb2277db237c1e4f30f25c0a537c6399b3b6f8a152401"
    sha256 cellar: :any, catalina:      "0365ceaca192b31aaac8f7a41feb007c8abc512ee646c76549097fd3b07a2cff"
    sha256 cellar: :any, mojave:        "0b3586bd18b9b2df18d46be4d6c1ca6bed3999708fa1d72fa0e0047a8a500839"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ghostscript"
  depends_on "jbig2enc"
  depends_on "leptonica"
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
    url "https://files.pythonhosted.org/packages/a8/20/025f59f929bbcaa579704f443a438135918484fffaacfaddba776b374563/cffi-1.14.5.tar.gz"
    sha256 "fd78e5fee591709f32ef6edb9a015b4aa1a5022598e36227500c8f4e02328d9c"
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
    url "https://files.pythonhosted.org/packages/9b/77/461087a514d2e8ece1c975d8216bc03f7048e6090c5166bc34115afdaa53/cryptography-3.4.7.tar.gz"
    sha256 "3d10de8116d25649631977cb37da6cbdd2d6fa0e0281d014a5b7d337255ca713"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/24/ca/f3a75b50d978872f6551d72c9c76890d68c84f3ba210cdba5f409587a2fc/humanfriendly-9.2.tar.gz"
    sha256 "f7dba53ac7935fd0b4a2fc9a29e316ddd9ea135fb3052d3d0279d10c18ff9c48"
  end

  resource "img2pdf" do
    url "https://files.pythonhosted.org/packages/a9/b4/b484d19a7c3565bbe47eb2118d323cb1e03456f70eb1c94e994ee5ece046/img2pdf-0.4.1.tar.gz"
    sha256 "38a1229ca84b211d7782d1d65ad7251a9781bf24f6f6497c738c755fcfed5552"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e5/21/a2e4517e3d216f0051687eea3d3317557bde68736f038a3b105ac3809247/lxml-4.6.3.tar.gz"
    sha256 "39b78571b3b30645ac77b95f7c69d1bffc4cf8c3b157c435a34da72e78c82468"
  end

  resource "pdfminer.six" do
    url "https://files.pythonhosted.org/packages/d8/bb/45cb24e715d3058f92f703265e6ed396767b19fec6d19d1ea54e04b730b7/pdfminer.six-20201018.tar.gz"
    sha256 "b9aac0ebeafb21c08bf65f2039f4b2c5f78a3449d0a41df711d72445649e952a"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/2b/55/6a6a82b13dcf181c1c61d51559893c9ed566767e25edc7b6f4cbba85c07f/pikepdf-2.13.0.tar.gz"
    sha256 "9484921319aa072f7471b823bd196879f97945e811f9d9bc0a15e52ae05a25b6"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f8/04/7a8542bed4b16a65c2714bf76cf5a0b026157da7f75e87cc88774aa10b14/pluggy-0.13.1.tar.gz"
    sha256 "15b2acde666561e1298d71b523007ed7364de07029219b604cf808bfa1c765b0"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "reportlab" do
    url "https://files.pythonhosted.org/packages/f8/3b/3684a3414cde1626be5245af21ace0629ceb1e38ff745a84e07349505827/reportlab-3.5.68.tar.gz"
    sha256 "efef6a97e3ab49f3f40037dbf9a4166668a17cc6aaba13d5ecbabdf854a9b332"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/f2/9c/99aae7670351c694c60c72e3cc834b7eab396f738b391bd0bdfc5101a663/tqdm-4.61.1.tar.gz"
    sha256 "24be966933e942be5f074c29755a95b315c69a91f839a29139bf26ffffe2d3fd"
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
