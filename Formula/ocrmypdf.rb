class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://github.com/jbarlow83/OCRmyPDF"
  url "https://files.pythonhosted.org/packages/c1/32/06c0381653284bab21b26612dee0c923440f35143e59a43a744e4cf1bd12/ocrmypdf-7.2.1.tar.gz"
  sha256 "e56902d370f3d4766432e7b7f300fd4b0ed51bd98dedadc3923b8af20471b528"

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
    url "https://files.pythonhosted.org/packages/09/ef/db0bc644097f52382f8040633ca8bc49b04a54dfbf76147c495398e2949b/pikepdf-0.3.5.tar.gz"
    sha256 "661d38fd54bf419549bb162b9dab6699395896a52e10ca5d0b52610806122d69"
  end

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/d3/c4/b45b9c0d549f482dd072055e2d3ced88f3b977f7b87c7a990228b20e7da1/Pillow-5.2.0.tar.gz"
    sha256 "f8b3d413c5a8f84b12cd4c5df1d8e211777c9852c6be3ee9c094b626644d3eab"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "python-xmp-toolkit" do
    url "https://files.pythonhosted.org/packages/5b/0b/4f95bc448e4e30eb0e831df0972c9a4b3efa8f9f76879558e9123215a7b7/python-xmp-toolkit-2.0.1.tar.gz"
    sha256 "f8d912946ff9fd46ed5c7c355aa5d4ea193328b3f200909ef32d9a28a1419a38"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/ca/a9/62f96decb1e309d6300ebe7eee9acfd7bccaeedd693794437005b9067b44/pytz-2018.5.tar.gz"
    sha256 "ffb9ef1de172603304d9d2819af6f5ece76f2e85ec10692a524dd876e72bf277"
  end

  resource "reportlab" do
    url "https://files.pythonhosted.org/packages/70/4c/19fe74b800e7d74b3dd636137aac6e8df4b19286e318c1a5b6d8ca4b17fd/reportlab-3.5.6.tar.gz"
    sha256 "3836a49e7ea7bce458f437cbc094633c7fd4ac027180565875c18ecc726f261e"
  end

  resource "ruffus" do
    url "https://files.pythonhosted.org/packages/ea/32/5048607dd7a9104406789b15fb4078e774121b23190c9e464d4dd1f7ed89/ruffus-2.7.0.tar.gz"
    sha256 "4bd46461d31aa532357019a33d8045f4e57e52f4ee41643b5b3a7372e380cae0"
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
