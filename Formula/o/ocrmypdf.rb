class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://ocrmypdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/fa/fe/60bdc79529be1ad8b151d426ed2020d5ac90328c54e9ba92bd808e1535c1/ocrmypdf-17.3.0.tar.gz"
  sha256 "4022f13aad3f405e330056a07aa8bd63714b48b414693831b56e2cf2c325f52d"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eda3d600cb52fdf1d609a10ba0d40a10aed7b7e8febfc3bea40ebf01147b5e80"
    sha256 cellar: :any,                 arm64_sequoia: "d2aac374e80d2b64c7537b79de336512e5911a05bbc50c156cb3224d2e0c705f"
    sha256 cellar: :any,                 arm64_sonoma:  "2e8fcac4f5946532d984dd50a94bd29c29735dc43687ba8e9197851edbb8be91"
    sha256 cellar: :any,                 sonoma:        "0dde28a9811894e67b5cc580fd3673b5acf069bb06c474018a648529c2a9ec44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39dc07e9e04c13c6459d041d741c0cad11e3e81f70f2aa53aaacd13c10d682f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db735e75ae9af67a9beea2450959f8b215daa4b37c0f5c57db6afc0e523c2d68"
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
    url "https://files.pythonhosted.org/packages/74/3f/b23cf3a1943905645f44df95de8289770e69f85c9442abf89f93dc5c4a74/fpdf2-2.8.6.tar.gz"
    sha256 "5132f26bbeee69a7ca6a292e4da1eb3241147b5aea9348b35e780ecd02bf5fc2"
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
    url "https://files.pythonhosted.org/packages/c5/e2/ec73060f02e328bdeb86cb13c6717916fcb530c5fa595d5d48e4b831c675/pi_heif-1.2.1.tar.gz"
    sha256 "a5c5fd4d92b4f0541d8629eaadd95403ccdfd1b7f2ddced52844fa610713685d"
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
    url "https://files.pythonhosted.org/packages/fb/f6/42f5f1b9beb7e036f5532832b9c590fd107c52a78f704302c03bc6793954/pypdfium2-5.5.0.tar.gz"
    sha256 "3283c61f54c3c546d140da201ef48a51c18b0ad54293091a010029ac13ece23a"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/c6/f3b320c27991c46f43ee9d856302c70dc2d0fb2dba4842ff739d5f46b393/rich-14.3.3.tar.gz"
    sha256 "b8daa0b9e4eef54dd8cf7c86c03713f53241884e814f4e2f5fb342fe520f639b"
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
