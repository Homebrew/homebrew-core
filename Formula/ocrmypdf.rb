class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://github.com/jbarlow83/OCRmyPDF"
  url "https://files.pythonhosted.org/packages/f1/13/0bd18f6f3b0dad0c2b6301089cff4235bcadfd25d16b03e2fead618502bf/ocrmypdf-12.3.2.tar.gz"
  sha256 "e041aadce7f1b5fa67f2fdbd26b93ce41ddeb78695d5a9cec41bb2faaa920642"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6a7a7290e2162789b44871e594ab0f1228c99f1f3dae1cf2d97205361980c783"
    sha256 cellar: :any, big_sur:       "80f742de68ea08e75d49f1249db7d59da70f966088aa8f5e31efcb46110c2428"
    sha256 cellar: :any, catalina:      "b46495d42e7575cba8eeea075c5fce03c11022dd9d628050912c78624ec07fc9"
    sha256 cellar: :any, mojave:        "f4e8eb4df4c7be2d95944aedb4f9cc1b71d68ea6fc73f4c2b823e7d8f636ea07"
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
    url "https://files.pythonhosted.org/packages/2e/92/87bb61538d7e60da8a7ec247dc048f7671afe17016cd0008b3b710012804/cffi-1.14.6.tar.gz"
    sha256 "c9a875ce9d7fe32887784274dd533c57909b7b1dcadcc128a2ac21331a9765dd"
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
    url "https://files.pythonhosted.org/packages/d0/ef/fa6757e307049680f23ac03cc9f677354b4839302459b5d60198f72d89a4/pikepdf-2.16.1.tar.gz"
    sha256 "e24dff6af31f1eb732fcb5db4678835d1f312643996fdcd9dbeb8aca52bc0dde"
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
    url "https://files.pythonhosted.org/packages/7f/e6/23e3f15ff29970dd64065a9a27bc809b1df727f7f9f6dfa3e36cf7975e58/tqdm-4.62.0.tar.gz"
    sha256 "3642d483b558eec80d3c831e23953582c34d7e4540db86d9e5ed9dad238dabc6"
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
