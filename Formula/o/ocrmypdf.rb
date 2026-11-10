class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://ocrmypdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/6f/cc/f327a00c4e7f1eb241a27078ee12503cc31fcce1b018639441d2bd7b46d2/ocrmypdf-17.14.0.tar.gz"
  sha256 "834c51d1f91110e5e7b9ab83818c445a3336343d7f61acdf38db88272b0016ab"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "73c3e21393a60eedeab1dbf8f866d47ebf92d44d15535ff8f31e276c6dcfc7c5"
    sha256 cellar: :any, arm64_tahoe:       "c2fa1ee351893a0d257b91dc60e1ad73c98e3eab0dfb3576c4701be0f706c2ba"
    sha256 cellar: :any, arm64_sequoia:     "4827213d4e37b1bb3c8b52a434b2e3780817d802e8671a6ef4a7af7e3471658a"
    sha256 cellar: :any, arm64_linux:       "bd0768c2465db983ca096b3ed03a7c9bd01e058f172568f79f1e23a5d3fa0dc1"
    sha256 cellar: :any, x86_64_linux:      "3b838fc26460c98aa9b970bf371a39acffa3fc0dabd16dda85f4cd11740bf89d"
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
  depends_on "python@3.15"
  depends_on "qpdf"
  depends_on "rpds-py" => :no_linkage
  depends_on "tesseract"
  depends_on "unpaper"

  uses_from_macos "libffi"
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: %w[cryptography pillow pydantic rpds-py]

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/0c/b5/672312ae80ce8b8eb9779c56052a24c8f36652aa7293a1a420553bcf03e5/fonttools-4.68.0.tar.gz"
    sha256 "73294e233070f71e2b3653b6bd8564af676d57f26d075761fb06d1ab2e4a7a5d"
  end

  resource "fpdf2" do
    url "https://files.pythonhosted.org/packages/ec/be/440da8ede1cf7aaff73be5c5a6d0dc6f2938df6604ffbc313f9c6dc63f55/fpdf2-2.9.0.tar.gz"
    sha256 "af2e7e06a5a2f9e32e24b146b56f58166142dfff45f55370ab03bfac9c8e3e21"
  end

  resource "img2pdf" do
    url "https://files.pythonhosted.org/packages/8e/97/ca44c467131b93fda82d2a2f21b738c8bcf63b5259e3b8250e928b8dd52a/img2pdf-0.6.3.tar.gz"
    sha256 "219518020f5bd242bdc46493941ea3f756f664c2e86f2454721e74353f58cd95"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
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
    url "https://files.pythonhosted.org/packages/2e/5c/db56403f493bae2e35a0d5d2c9ad358b011f142b760282698a9f2732941e/pikepdf-10.18.0.tar.gz"
    sha256 "cb555ebff93482e8a6eb55881488b469bbb2b5675161c1b93a0510a8642d98d0"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/bf/db/7fc19e6f2dc92a966727031389fc2e08b558f0f25eb7403c1119ad4713cd/pluggy-1.7.0.tar.gz"
    sha256 "d1eaa46ebb595891b860ab086b4d09c8588af65ebd4361b8e8f4bb8920b90ba8"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pypdfium2" do
    url "https://files.pythonhosted.org/packages/7c/7d/c1761532c87e2da867a1049bf9142a17efec0b00c6326a51964bec2388ea/pypdfium2-5.15.0.tar.gz"
    sha256 "150f71bc385fe66d82fc59514b31d00dcfc97a1143d6b4cb09aa6f532f3f3510"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "uharfbuzz" do
    url "https://files.pythonhosted.org/packages/e6/48/0b293baafb87b5ccfec082f427fb1e81ce4d27098a8b2ac8db6c76e07e65/uharfbuzz-0.57.0.tar.gz"
    sha256 "55136df18a9dd09fec36d1ceb77965f3108de6d86c338b3825feedb0730d84b7"
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
