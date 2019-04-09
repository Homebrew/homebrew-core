class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://github.com/jbarlow83/OCRmyPDF"
  url "https://files.pythonhosted.org/packages/95/13/cafafdc0c7eb30de9063b1826a521417694d7d4ed7055769db96550637ec/ocrmypdf-8.2.2.tar.gz"
  sha256 "24822bdcac7c3eddd0411f60ac6f365badd6788eb659c298758d8819fd33053d"

  bottle do
    cellar :any
    sha256 "7ca08e935beb6f45950eb0a679457d40c23fde236895e564842d647522e39633" => :mojave
    sha256 "02d903c799d26c24d89cd78af3cf69182bd77c40446be1d63fb66aac7a7189da" => :high_sierra
    sha256 "b09d2ed737b8b11e627174d6ba071640104c6e1de3006b19d0944aee752a139e" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "exempi"
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "jbig2enc"
  depends_on "jpeg"
  depends_on "leptonica"
  depends_on "libpng"
  depends_on "pngquant"
  depends_on "pybind11"
  depends_on "python"
  depends_on "qpdf"
  depends_on "tesseract"
  depends_on "unpaper"

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/64/7c/27367b38e6cc3e1f49f193deb761fe75cda9f95da37b67b422e62281fcac/cffi-1.12.2.tar.gz"
    sha256 "e113878a446c6228669144ae8a56e268c91b7f1fafae927adc4879d9849e0ea7"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/74/ba/4ba4e89e21b5a2e267d80736ea674609a0a33cc4435a6d748ef04f1f9374/defusedxml-0.5.0.tar.gz"
    sha256 "24d7f2f94f7f3cb6061acb215685e5125fbcdc40a857eff9de22518820b0a4f4"
  end

  resource "img2pdf" do
    url "https://files.pythonhosted.org/packages/e0/c6/7cd14232a1b10bf884c12daf3626afb76c4f60b52ae0eb23ce1519542ae4/img2pdf-0.3.3.tar.gz"
    sha256 "9d77c17ee65a736abe92ef8cba9cca009c064ea4ed74492c01aea596e41856cf"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/16/4a/b085a04d6dad79aa5c00c65c9b2bbcb2c6c22e5ac341e7968e0ad2c57e2f/lxml-4.3.0.tar.gz"
    sha256 "d1e111b3ab98613115a208c1017f266478b0ab224a67bc8eac670fa0bad7d488"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/d0/de/87be0b2b9dd5626d87df75f7f5ee04276cde661095eb4f854193eeaa32c4/pikepdf-1.1.0.tar.gz"
    sha256 "be826ba57db1a928ca0b95d7513e1c45cb7042ddf88adbb5f80881014d366391"
  end

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/3c/7e/443be24431324bd34d22dd9d11cc845d995bcd3b500676bcf23142756975/Pillow-5.4.1.tar.gz"
    sha256 "5233664eadfa342c639b9b9977190d64ad7aca4edc51a966394d7e08e7f38a9f"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz"
    sha256 "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/af/be/6c59e30e208a5f28da85751b93ec7b97e4612268bb054d0dff396e758a90/pytz-2018.9.tar.gz"
    sha256 "d5f05e487007e29e03409f9398d074e158d920d36eb82eaf66fb1136b0c5374c"
  end

  resource "reportlab" do
    url "https://files.pythonhosted.org/packages/6d/b5/495011623878f1000a2bfa62fa54c3b491071f0c77062dcd1bd86e2b9764/reportlab-3.5.13.tar.gz"
    sha256 "6116e750f98018febc08dfee6df20446cf954adbcfa378d2c703d56c8864aff3"
  end

  resource "ruffus" do
    url "https://files.pythonhosted.org/packages/18/24/05e8fe590d08bd9e6122c6a87425ff741c79edf01d2873f92028e860e547/ruffus-2.8.1.tar.gz"
    sha256 "90bc1e57ffb95be11e9c4461a406fee63395898beacd35a1dce9dd2c468c2582"
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
  end

  test do
    # Since we use Python 3, we require a UTF-8 locale
    ENV["LC_ALL"] = "en_US.UTF-8"

    system "#{bin}/ocrmypdf", "-f", "-q", "--deskew",
                              test_fixtures("test.pdf"), "ocr.pdf"
    assert_predicate testpath/"ocr.pdf", :exist?
  end
end
