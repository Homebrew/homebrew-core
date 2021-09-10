class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://github.com/jbarlow83/OCRmyPDF"
  url "https://files.pythonhosted.org/packages/34/64/5592a77a2809e43df7add6d8e38ae4c9c3bdc38d007f046a8bf135b6d5db/ocrmypdf-12.4.0.tar.gz"
  sha256 "94c1bbc93a93493388930bbc6ede131ea3a17c30476033d99162647c0dc874f6"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "fcdac71e2d5929d9a4d2f9c7be15254229a4efa6c1efb0a922d47010b7cfd82f"
    sha256 cellar: :any,                 big_sur:       "4e03f2d06bb64fbfa83cb3fcddaa55a1c334306315f351b4c452e9f84662aee3"
    sha256 cellar: :any,                 catalina:      "cfb0a84a216425fa7c46d285ab38fae1e1117b9fc7aa958bd86b02d861005bb4"
    sha256 cellar: :any,                 mojave:        "62bf0675bb4018903f8e9de755c2b6c1960ed0f467ff70fec3fe5973d5fa4980"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "097ce6c4d8aaac43db65ab1f577438f13ec6dbcc05f3565abdb032a604ba1c96"
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
    url "https://files.pythonhosted.org/packages/cc/98/8a258ab4787e6f835d350639792527d2eb7946ff9fc0caca9c3f4cf5dcfe/cryptography-3.4.8.tar.gz"
    sha256 "94cc5ed4ceaefcbe5bf38c8fba6a21fc1d365bb8fb826ea1688e3370b2e24a1c"
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
    url "https://files.pythonhosted.org/packages/a1/16/db2d7de3474b6e37cbb9c008965ee63835bba517e22cdb8c35b5116b5ce1/pluggy-1.0.0.tar.gz"
    sha256 "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "reportlab" do
    url "https://files.pythonhosted.org/packages/df/3f/58e3a3dd81190ebfcdc3f79191f95898b21356e2f79e0dabcbdc07af2a94/reportlab-3.6.1.tar.gz"
    sha256 "68f9324000cfc5570b5a59a92306691b5d655078a399f20bc72c2581fe903261"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/37/e5/1b54ef934d731576d0145bc8ae22da5b410f96922cec52b91cc29d3ff1b6/tqdm-4.62.2.tar.gz"
    sha256 "a4d6d112e507ef98513ac119ead1159d286deab17dffedd96921412c2d236ff5"
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
