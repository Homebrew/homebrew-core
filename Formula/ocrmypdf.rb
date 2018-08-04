class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://github.com/jbarlow83/OCRmyPDF"
  url "https://files.pythonhosted.org/packages/ca/80/3ec566e800057bfb9c7d9c7278eb7fcc6d2f15195e544214433c649a6daf/ocrmypdf-7.0.2.tar.gz"
  sha256 "0070cec34acda08a06667fe6ab6bca3257822811428cd455198071a465eb777e"

  bottle do
    cellar :any
    sha256 "081ea75465e97ee4b40d934c37f6af574a34edc6a1bf83c9373b9c132d51c3af" => :high_sierra
    sha256 "6575e2c4bde8248c2535287102342acf01581f7fd486bf07991fbca49b3a1920" => :sierra
    sha256 "4d77463bd4ce21f98293b332d9137365cf8247a0fc187c93e85b564e69f04953" => :el_capitan
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
    url "https://files.pythonhosted.org/packages/a6/5a/410a05ebefe60885dd8a13e18b82692d23bbf0fc74f2807b0ae3e7c6bfb1/img2pdf-0.3.0.tar.gz"
    sha256 "8d81bb05abfe73172a31afced1019e7636aaddd13a75207daef032350cec21fc"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/39/97/9dd6f1e2158f61100f2cb8828de2e6f35f9edb634af405ecc0146ba70567/pikepdf-0.3.0.tar.gz"
    sha256 "c757a3d84b09494f0b402b890511107da3a9f4d845a53d142edfb69b1165ffe7"
  end

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/d3/c4/b45b9c0d549f482dd072055e2d3ced88f3b977f7b87c7a990228b20e7da1/Pillow-5.2.0.tar.gz"
    sha256 "f8b3d413c5a8f84b12cd4c5df1d8e211777c9852c6be3ee9c094b626644d3eab"
  end

  resource "pybind11" do
    url "https://files.pythonhosted.org/packages/95/30/788a5c943f1399e05b52148504dffa7a801ea52eb5bb5cac0cc828306278/pybind11-2.2.3.tar.gz"
    sha256 "87ff3ae777d9326349af5272974581270b2a0909b2392dc0cc57eb28ce23bcc3"
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
    url "https://files.pythonhosted.org/packages/54/8b/ebc5f52dfd8175b7e831caae7f1c491cdef5834667bd6e5fd41627b5c07a/reportlab-3.5.2.tar.gz"
    sha256 "08986267eaf25d62c3802512f0a97dc3426d0c82f52c8beb576689582eb85b7f"
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

    # pybind11 must be installed before pikepdf
    venv.pip_install "pybind11"

    res = resources.map(&:name).to_set - ["Pillow", "pybind11"]
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
