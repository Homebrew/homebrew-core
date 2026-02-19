class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://ocrmypdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/1b/25/7e1e88a4efbfb4ed7569894da9454503f0b30ddc9d7436378e179ab45196/ocrmypdf-17.2.0.tar.gz"
  sha256 "ad4dc266f6cf63608716707a76c54177687c422c75ee301d454b3d9b1d9b434a"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "80084158e205e37d8d3dd295ea9764f3823a722e83d2a201052a3554de7c0e2a"
    sha256 cellar: :any,                 arm64_sequoia: "9ffe4f0c067d3f5ce05b3616bf2e7e7aa83c87bd95782a8f6a97376c0d6a76e6"
    sha256 cellar: :any,                 arm64_sonoma:  "302647977521430f6507a754349d3efae1f036432226f9b68fc2fae2f5602bf1"
    sha256 cellar: :any,                 sonoma:        "9c769a0611fc0193e3d0b403be6a000d472f68378474c56f46576585b72c5f04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50b65ce27d48907758e5f0480d1fb61a36c98b9b7c6785145850e77ba5f0890e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d07a59e57226fc7cc7f586ad9fec7ca7e9490d1039f00ae7992af1a649cd0a0f"
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
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"
  depends_on "qpdf"
  depends_on "tesseract"
  depends_on "unpaper"

  uses_from_macos "libffi"
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: %w[cryptography pillow pydantic]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/49/85/12f0a49a7c4ffb70572b6c2ef13c90c88fd190debda93b23f026b25f9634/deprecated-1.3.1.tar.gz"
    sha256 "b1b50e0ff0c1fddaa5708a2c6b0a6588bb09b892825ab2b214ac9ea9d92a5223"
  end

  resource "deprecation" do
    url "https://files.pythonhosted.org/packages/5a/d3/8ae2869247df154b64c1884d7346d412fed0c49df84db635aab2d1c40e62/deprecation-2.1.0.tar.gz"
    sha256 "72b3bde64e5d778694b0cf68178aed03d15e15477116add3fb773e581f9518ff"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/ec/ca/cf17b88a8df95691275a3d77dc0a5ad9907f328ae53acbe6795da1b2f5ed/fonttools-4.61.1.tar.gz"
    sha256 "6675329885c44657f826ef01d9e4fb33b9158e9d93c537d84ad8399539bc6f69"
  end

  resource "fpdf2" do
    url "https://files.pythonhosted.org/packages/e9/c0/784b130a28f4ed612e9aff26d1118e1f91005713dcd0a35e60b54d316b56/fpdf2-2.8.5.tar.gz"
    sha256 "af4491ef2e0a5fe476f9d61362925658949c995f7e804438c0e81008f1550247"
  end

  resource "img2pdf" do
    url "https://files.pythonhosted.org/packages/8e/97/ca44c467131b93fda82d2a2f21b738c8bcf63b5259e3b8250e928b8dd52a/img2pdf-0.6.3.tar.gz"
    sha256 "219518020f5bd242bdc46493941ea3f756f664c2e86f2454721e74353f58cd95"
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
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "pdfminer-six" do
    url "https://files.pythonhosted.org/packages/34/a4/5cec1112009f0439a5ca6afa8ace321f0ab2f48da3255b7a1c8953014670/pdfminer_six-20260107.tar.gz"
    sha256 "96bfd431e3577a55a0efd25676968ca4ce8fd5b53f14565f85716ff363889602"
  end

  resource "pi-heif" do
    url "https://files.pythonhosted.org/packages/c5/0b/0c97767b8171c7f9f0584c0a70e7b86655a1898c2f5b8ae04a69f4e481a1/pi_heif-1.2.0.tar.gz"
    sha256 "52bbbc8c30b803288a9f1bb02e4575797940fdc1f5091fce743c699e812418cc"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/b6/ba/7635a5f4259a2a91ed4f094e358dec3068ecedc891d70b8e76a02904ca0c/pikepdf-10.3.0.tar.gz"
    sha256 "e2a64a5f1ebf8c411193126b9eeff7faf5739a40bce7441e579531422469fbb1"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pypdfium2" do
    url "https://files.pythonhosted.org/packages/99/23/b3979a1d4f536fabce02e3d9f332e8aeeed064d9df9391f2a77160f4ab36/pypdfium2-5.4.0.tar.gz"
    sha256 "7219e55048fb3999fc8adcaea467088507207df4676ff9e521a3ae15a67d99c4"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/74/99/a4cab2acbb884f80e558b0771e97e21e939c5dfb460f488d19df485e8298/rich-14.3.2.tar.gz"
    sha256 "e712f11c1a562a11843306f5ed999475f09ac31ffb64281f73ab29ffdda8b3b8"
  end

  resource "uharfbuzz" do
    url "https://files.pythonhosted.org/packages/1c/8d/7c82298bfa5c96f018541661bc2ccdf90dfe397bb2724db46725bf495466/uharfbuzz-0.53.3.tar.gz"
    sha256 "9a87175c14d1361322ce2a3504e63c6b66062934a5edf47266aed5b33416806c"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/f7/37/ae31f40bec90de2f88d9597d0b5281e23ffe85b893a47ca5d9c05c63a4f6/wrapt-2.1.1.tar.gz"
    sha256 "5fdcb09bf6db023d88f312bd0767594b414655d58090fc1c46b3414415f67fac"
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
