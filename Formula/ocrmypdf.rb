class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://github.com/jbarlow83/OCRmyPDF"
  url "https://files.pythonhosted.org/packages/6b/8c/d8a9132e050ac25ea5da63fabc1a1fc0246beee72701b372c35221a40237/ocrmypdf-9.0.3.tar.gz"
  sha256 "3d9b92f6a01d0711e4156c6b36638d9d946d010e2925ec473ec7f666096cceeb"
  revision 1

  bottle do
    cellar :any
    sha256 "14b8ff913b3a84a6dd198d6ed318761b41e1e018a8f6502138eff8e38f6bab5a" => :mojave
    sha256 "2608e903577d8ebdbe413a24e8f145e71a113fd1dd4f6f5933cce86550f71729" => :high_sierra
    sha256 "ab2dc2763186d2286e472458594127126667ad9c1a8c2937435afefa81ee68ee" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "jbig2enc"
  depends_on "jpeg"
  depends_on "leptonica"
  depends_on "libpng"
  depends_on "libxml2"
  depends_on "pngquant"
  depends_on "pybind11"
  depends_on "python"
  depends_on "qpdf"
  depends_on "tesseract"
  depends_on "unpaper"

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/93/1a/ab8c62b5838722f29f3daffcc8d4bd61844aa9b5f437341cc890ceee483b/cffi-1.12.3.tar.gz"
    sha256 "041c81822e9f84b1d9c401182e174996f0bae9991f33725d059b771744290774"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "img2pdf" do
    url "https://files.pythonhosted.org/packages/e0/c6/7cd14232a1b10bf884c12daf3626afb76c4f60b52ae0eb23ce1519542ae4/img2pdf-0.3.3.tar.gz"
    sha256 "9d77c17ee65a736abe92ef8cba9cca009c064ea4ed74492c01aea596e41856cf"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/c4/43/3f1e7d742e2a7925be180b6af5e0f67d38de2f37560365ac1a0b9a04c015/lxml-4.4.1.tar.gz"
    sha256 "c81cb40bff373ab7a7446d6bbca0190bccc5be3448b47b51d729e37799bb5692"
  end

  resource "pdfminer.six" do
    url "https://files.pythonhosted.org/packages/0d/b4/26801ccc18c3622471a39eb17ab3839c91e4c48dd3e235a22130e09edc6f/pdfminer.six-20181108.tar.gz"
    sha256 "9cc58857cf0a360213008061d903282462abee55cdcc7e0b6e08d6834e55050d"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/43/14/934f82ef48e0c06feef4e8561a645f9c755e0cc50d92f846c1f491456714/pikepdf-1.6.4.tar.gz"
    sha256 "50ad2f2903db21b9105c1092ef947b456134a77355b4386535492dc28a6a4e52"
  end

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/51/fe/18125dc680720e4c3086dd3f5f95d80057c41ab98326877fc7d3ff6d0ee5/Pillow-6.1.0.tar.gz"
    sha256 "0804f77cb1e9b6dbd37601cee11283bba39a8d44b9ddb053400c58e0c0d7d9de"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz"
    sha256 "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/b6/41/d3749c0caa860041eb6b0832c7087253d59cb5af8bb303a8d4b6daa74014/pycryptodome-3.9.0.tar.gz"
    sha256 "dbeb08ad850056747aa7d5f33273b7ce0b9a77910604a1be7b7a6f2ef076213f"
  end

  resource "reportlab" do
    url "https://files.pythonhosted.org/packages/41/93/c57ed3f33daabaad2146504d888ea77c44d35fa57bf844342a70f4593007/reportlab-3.5.23.tar.gz"
    sha256 "6c81ee26753fa09062d8404f6340eefb02849608b619e3843e0d17a7cda8798f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/29/e0/135df2e733790a3d3bcda970fd080617be8cea3bd98f411e76e6847c17ef/sortedcontainers-2.1.0.tar.gz"
    sha256 "974e9a32f56b17c1bac2aebd9dcf197f3eb9cd30553c5852a3187ad162e1a03a"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/d0/10/54a72929d8b042965180f01cbf0701b5377c5cce0148c552807d195d8d0b/tqdm-4.35.0.tar.gz"
    sha256 "1be3e4e3198f2d0e47b928e9d9a8ec1b63525db29095cec1467f4c5a4ea8ebf9"
  end

  def install
    venv = virtualenv_create(libexec, "python3")

    resource("Pillow").stage do
      inreplace "setup.py" do |s|
        sdkprefix = MacOS.sdk_path_if_needed ? MacOS.sdk_path : ""
        s.gsub! "openjpeg.h", "probably_not_a_header_called_this_eh.h"
        s.gsub! "ZLIB_ROOT = None", "ZLIB_ROOT = ('#{sdkprefix}/usr/lib', '#{sdkprefix}/usr/include')"
        s.gsub! "JPEG_ROOT = None", "JPEG_ROOT = ('#{Formula["jpeg"].opt_prefix}/lib', '#{Formula["jpeg"].opt_prefix}/include')"
        s.gsub! "FREETYPE_ROOT = None", "FREETYPE_ROOT = ('#{Formula["freetype"].opt_prefix}/lib', '#{Formula["freetype"].opt_prefix}/include')"
      end

      # avoid triggering "helpful" distutils code that doesn't recognize Xcode 7 .tbd stubs
      ENV.append "CFLAGS", "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers" unless MacOS::CLT.installed?
      venv.pip_install Pathname.pwd
    end

    # Fix "ld: file not found: /usr/lib/system/libsystem_darwin.dylib" for lxml
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    res = resources.map(&:name).to_set - ["Pillow"]
    res.each do |r|
      venv.pip_install resource(r)
    end

    venv.pip_install_and_link buildpath
    bash_completion.install "misc/completion/ocrmypdf.bash" => "ocrmypdf"
    fish_completion.install "misc/completion/ocrmypdf.fish"
  end

  test do
    system "#{bin}/ocrmypdf", "-f", "-q", "--deskew",
                              test_fixtures("test.pdf"), "ocr.pdf"
    assert_predicate testpath/"ocr.pdf", :exist?
  end
end
