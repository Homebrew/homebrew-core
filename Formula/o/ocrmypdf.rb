class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://ocrmypdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/37/b5/2ffe5431eb7a8e4fb620d30351e06b8f97212800d23145979c459784bea0/ocrmypdf-17.12.1.tar.gz"
  sha256 "aca73a23a80cf2f46a4c15040b0035203dbf74054b7a0c3a7ee93b05abc555a6"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b346f5e02faff0e08b77de78c4796b490919ce5a3d1cf82399ad96c98bca44fd"
    sha256 cellar: :any, arm64_tahoe:       "064085f3ad6a80e9ff2c4193fe8b7c8d51bc8da23729834b80ed3612515d334f"
    sha256 cellar: :any, arm64_sequoia:     "38cdb109911e52c5e7206dae205df0305ea838d9188573e2e7e668c6e8da634c"
    sha256 cellar: :any, arm64_linux:       "baab52bfdefafc6e5a4b51fa46bff46ea2b2c0c9c965f60ef579ae55dfed9e7e"
    sha256 cellar: :any, x86_64_linux:      "c71b2f074aadf6c19e5694a7c93e2b3e267dd1264b036c0dad991f034535e247"
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
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/77/51/d63c7e52163ac14393a35bd14bd7c0da95f8f74be5d7cc988092f9965129/fonttools-4.65.0.tar.gz"
    sha256 "762ba5431358d0dbd4a01982484a1d494fb267e91f974cdcf20b80eab8560f6f"
  end

  resource "fpdf2" do
    url "https://files.pythonhosted.org/packages/1e/bc/8fd4321aed40cadadddc8f311c65b6082346b252bca048f7b476d8f35d72/fpdf2-2.8.8.tar.gz"
    sha256 "9e94e155e85e8053329a9a1fce8b566fd7a7c5bb79e98a1a3952d379b947c5b9"
  end

  resource "img2pdf" do
    url "https://files.pythonhosted.org/packages/8e/97/ca44c467131b93fda82d2a2f21b738c8bcf63b5259e3b8250e928b8dd52a/img2pdf-0.6.3.tar.gz"
    sha256 "219518020f5bd242bdc46493941ea3f756f664c2e86f2454721e74353f58cd95"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pdfminer-six" do
    url "https://files.pythonhosted.org/packages/34/a4/5cec1112009f0439a5ca6afa8ace321f0ab2f48da3255b7a1c8953014670/pdfminer_six-20260107.tar.gz"
    sha256 "96bfd431e3577a55a0efd25676968ca4ce8fd5b53f14565f85716ff363889602"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/1c/0e/6e74dd213537b71c945743a4b3112dbb430896ad68b8a6ad22e4468455d4/pikepdf-10.13.0.post1.tar.gz"
    sha256 "4b73f926ebae81f04bf14527af330bd00bb268be767e0f189f7c4c3e4ad7ae0a"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pypdfium2" do
    url "https://files.pythonhosted.org/packages/ec/78/a52cb80611339ec95f35c7a10d7bfe7a6f97f3b50a35a9f94283d062512e/pypdfium2-5.13.0.tar.gz"
    sha256 "7ca2d8e31bd8d0d40c496416b7d8bea423388669ffd494929f50e8c3a82326b8"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "uharfbuzz" do
    url "https://files.pythonhosted.org/packages/60/77/48457fb0c51f6f8c1e3082b126322e075d60fea60ee0df2b18cc050d9874/uharfbuzz-0.56.1.tar.gz"
    sha256 "a0a6928ed66b166a931ebe5df9ac551b9c42983513030233dcd95b41fa827f97"
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
