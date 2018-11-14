class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://github.com/jbarlow83/OCRmyPDF"
  url "https://github.com/jbarlow83/OCRmyPDF/archive/v7.3.0.tar.gz"
  sha256 "d73bd5fb01e022048e24c5d6694b9aa5bed0d591577d5c2e9995c9f857d65590"

  bottle do
    cellar :any
    sha256 "b1773b6a2657a167042cbd03c04e4051187dff8d2cb1f656863b8220a03de426" => :mojave
    sha256 "54f466af800ce1ef583e2a8b3f5e8a1170777179021d8c7bedce6bb7ce0ba236" => :high_sierra
    sha256 "af698a28872bebdcbc8123f22a43f7ae9176796b746ee46283df15a433fabb7c" => :sierra
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
    url "https://files.pythonhosted.org/packages/e7/a7/4cd50e57cc6f436f1cc3a7e8fa700ff9b8b4d471620629074913e3735fb2/cffi-1.11.5.tar.gz"
    sha256 "e90f17980e6ab0f3c2f3730e56d1fe9bcba1891eeea58966e89d352492cc74f4"
  end

  resource "img2pdf" do
    url "https://files.pythonhosted.org/packages/3e/40/aa7b63857908566b76d1849065a700248b088bf502c244e839fa2548d99e/img2pdf-0.3.1.tar.gz"
    sha256 "4409c12293eca94fdcd8e0da1ad2392b6ee3adfcedf438bb8b685924dc1b3a1c"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/ea/8d/01f66685772025ac82c63c759b032d5df2a0714a7f59292c393a084cb42e/pikepdf-0.3.7.tar.gz"
    sha256 "870c930e3450656b6da793968124ea9c509370deb413479652e0787b655d3290"
  end

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/1b/e1/1118d60e9946e4e77872b69c58bc2f28448ec02c99a2ce456cd1a272c5fd/Pillow-5.3.0.tar.gz"
    sha256 "2ea3517cd5779843de8a759c2349a3cd8d3893e03ab47053b66d5ec6f8bc4f93"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz"
    sha256 "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
  end

  resource "python-xmp-toolkit" do
    url "https://files.pythonhosted.org/packages/5b/0b/4f95bc448e4e30eb0e831df0972c9a4b3efa8f9f76879558e9123215a7b7/python-xmp-toolkit-2.0.1.tar.gz"
    sha256 "f8d912946ff9fd46ed5c7c355aa5d4ea193328b3f200909ef32d9a28a1419a38"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/cd/71/ae99fc3df1b1c5267d37ef2c51b7d79c44ba8a5e37b48e3ca93b4d74d98b/pytz-2018.7.tar.gz"
    sha256 "31cb35c89bd7d333cd32c5f278fca91b523b0834369e757f4c5641ea252236ca"
  end

  resource "reportlab" do
    url "https://files.pythonhosted.org/packages/6d/40/e0230c95234a16accad10bb50228b3b274c92797c92bcc423db70e0396c0/reportlab-3.5.9.tar.gz"
    sha256 "f92f81314807cd860f29fe07a1a4100b03910ae6bbfca20a07e02c3b460f4f20"
  end

  resource "ruffus" do
    url "https://files.pythonhosted.org/packages/ac/c7/5652e44a3644dfdf8cdfa17c2bb7933896dddec99888f57bf2adbbcca226/ruffus-2.8.0.tar.gz"
    sha256 "609e76e88de2d11362ed2a312917508f14daf56413fd1b3c7d5a96aaa14bb5e9"
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
