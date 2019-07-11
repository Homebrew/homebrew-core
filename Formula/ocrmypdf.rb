class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://github.com/jbarlow83/OCRmyPDF"
  url "https://files.pythonhosted.org/packages/6e/8b/2b724788302d51a3b90fe0c404709735f2ab8e1b5ba34588625c02e45c2e/ocrmypdf-8.3.2.tar.gz"
  sha256 "926a856981ca49c332253804eb566ccdf5a4ec9d6c0a94c4316fcb7ad0b9178e"

  bottle do
    cellar :any
    sha256 "919acaa8bc5a0546f3a001cdeb7eb2c27c37b8116762fc7e9c08dd662c88bf4c" => :mojave
    sha256 "7fe193aacb5926e7f1e5cd597749301674d68b7110fafae339fc3f5137f41343" => :high_sierra
    sha256 "c4c24f3fa8123ddd7cbdc8d347e3816570ac65dc3b8baa16741eb5ad5823530f" => :sierra
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
    url "https://files.pythonhosted.org/packages/7d/29/174d70f303016c58bd790c6c86e6e86a9d18239fac314d55a9b7be501943/lxml-4.3.3.tar.gz"
    sha256 "4a03dd682f8e35a10234904e0b9508d705ff98cf962c5851ed052e9340df3d90"
  end

  resource "pdfminer.six" do
    url "https://files.pythonhosted.org/packages/0d/b4/26801ccc18c3622471a39eb17ab3839c91e4c48dd3e235a22130e09edc6f/pdfminer.six-20181108.tar.gz"
    sha256 "9cc58857cf0a360213008061d903282462abee55cdcc7e0b6e08d6834e55050d"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/d2/94/55623d1e6813f8f2d36b48bb25066bdcb91ed7ba7d9b62a29d61b4ca3ff4/pikepdf-1.5.0.post0.tar.gz"
    sha256 "55d2dcbc8ed9c30d8f81add75b082b0fb89014fd8f2e0b8d464aef87f8f9d130"
  end

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/81/1a/6b2971adc1bca55b9a53ed1efa372acff7e8b9913982a396f3fa046efaf8/Pillow-6.0.0.tar.gz"
    sha256 "809c0a2ce9032cbcd7b5313f71af4bdc5c8c771cb86eb7559afd954cab82ebb5"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz"
    sha256 "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/c0/1e/5398467ff0fcb39dbb23412c5ea9c9b2db2b659282e49d4073daae952247/pycryptodome-3.8.1.tar.gz"
    sha256 "68ad0ce4a374577a26bb7f458575abe3c2a342818b5280de6e5738870b7761b3"
  end

  resource "reportlab" do
    url "https://files.pythonhosted.org/packages/dd/dc/200a6113b14d41309898347270ba3d2190f10b26f399f7ad3e4f4611fd77/reportlab-3.5.20.tar.gz"
    sha256 "7b248d2d9d4ab6d4cad91eb2b153b2c4c7b3fced89cb5a5b5bfbc7d09593871a"
  end

  resource "ruffus" do
    url "https://files.pythonhosted.org/packages/18/24/05e8fe590d08bd9e6122c6a87425ff741c79edf01d2873f92028e860e547/ruffus-2.8.1.tar.gz"
    sha256 "90bc1e57ffb95be11e9c4461a406fee63395898beacd35a1dce9dd2c468c2582"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/29/e0/135df2e733790a3d3bcda970fd080617be8cea3bd98f411e76e6847c17ef/sortedcontainers-2.1.0.tar.gz"
    sha256 "974e9a32f56b17c1bac2aebd9dcf197f3eb9cd30553c5852a3187ad162e1a03a"
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
