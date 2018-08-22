class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://github.com/jbarlow83/OCRmyPDF"
  url "https://files.pythonhosted.org/packages/bd/78/26738c05ad79a67e315490463d974e98bb682c989eef3c9cf067f64bb81f/ocrmypdf-7.0.3.tar.gz"
  sha256 "ba330ba8a82a228986d5d00d6147c1f2a51d8456065608af1e9160f8d454428a"

  bottle do
    cellar :any
    sha256 "60ca4daaa562cf295e2e51811e6acee0deeaa100a011367d99d235c7eb997ebe" => :high_sierra
    sha256 "7b258c1de7658b01e055af5c2128b8d3bd7fbeb1881558676cacf48c2c090f71" => :sierra
    sha256 "a95fa4f5e8180c26349d7bfb145672e0d83d5b34fcfa017ff8258eda04989156" => :el_capitan
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
    url "https://files.pythonhosted.org/packages/cd/e8/1de3832c09826b50babefe0d833e452bb2caee61800b047d1094f9fde5ec/pikepdf-0.3.1.tar.gz"
    sha256 "7cdf0a874de395c8cf00c92605a7c55445bbf41df9f0aae7c4d1625b66c4be26"
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
    url "https://files.pythonhosted.org/packages/20/79/533165435ad718d6ab3cc5ec40c1ac31654809db8f6510329b5eb2ef50fd/reportlab-3.5.5.tar.gz"
    sha256 "d18485c5b7561519138fd94a29239d8361cb3e204d38342f98f40c8d7774b4a5"
  end

  resource "ruffus" do
    url "https://files.pythonhosted.org/packages/ea/32/5048607dd7a9104406789b15fb4078e774121b23190c9e464d4dd1f7ed89/ruffus-2.7.0.tar.gz"
    sha256 "4bd46461d31aa532357019a33d8045f4e57e52f4ee41643b5b3a7372e380cae0"
  end

  def install
    venv = virtualenv_create(libexec, "python3")

    resource("Pillow").stage do
      inreplace "setup.py" do |s|
        sdkprefix = MacOS::CLT.installed? ? "" : MacOS.sdk_path
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
