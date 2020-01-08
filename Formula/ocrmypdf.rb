class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://github.com/jbarlow83/OCRmyPDF"
  url "https://files.pythonhosted.org/packages/d6/fb/324e8d0c819def5d9c3867648122a3f89bea66c476e08857e44c1f524d52/ocrmypdf-9.4.0.tar.gz"
  sha256 "0a5b6764a04ef3367e9e4e6d8619aee53a037d1bb3db39b99b43b75b0b1095d9"

  bottle do
    cellar :any
    sha256 "ccdd7cbcf9fde3736bc302777374212923fb0643a8e34d428dcedb92aeb73a6b" => :catalina
    sha256 "b3ebc1d949f661766fd425967ca75879f74ba83af160aa1cce8befdca421acfa" => :mojave
    sha256 "19908fb08bfed2e67f57a82bc4319b3f4405497d13afa57aceed3308a6f271e6" => :high_sierra
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

  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2d/bf/960e5a422db3ac1a5e612cb35ca436c3fc985ed4b7ed13a1b4879006f450/cffi-1.13.2.tar.gz"
    sha256 "599a1e8ff057ac530c9ad1778293c665cb81a791421f46922d80a86473c13346"
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
    url "https://files.pythonhosted.org/packages/e4/19/8dfeef50623892577dc05245093e090bb2bab4c8aed5cad5b03208959563/lxml-4.4.2.tar.gz"
    sha256 "eff69ddbf3ad86375c344339371168640951c302450c5d3e9936e98d6459db06"
  end

  resource "pdfminer.six" do
    url "https://files.pythonhosted.org/packages/f6/07/db4394f5fccbac38b18c723250cf98386f0a2bc51dc1db6eb19c33d332ba/pdfminer.six-20200104.tar.gz"
    sha256 "73468b9ffe28b0704e47544b1669a1a8197cefae81615ea1286900db702d4674"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/95/0a/72bd2b4fc2e8395ea98f8eaf6ba0f465267ed62d39db36a790f926c19fa8/pikepdf-1.8.3.tar.gz"
    sha256 "47a6308c3c2af738161200c1f388cbfdfb54140876c01205104bc2a711b03af7"
  end

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/39/47/f28067b187dd664d205f75b07dcc6e0e95703e134008a14814827eebcaab/Pillow-7.0.0.tar.gz"
    sha256 "4d9ed9a64095e031435af120d3c910148067087541131e82b3e8db302f4c8946"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz"
    sha256 "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/2a/f4/dd7f09f4635962b0283bd8020d686e5ced9e4f05259cab8d7926c696bee1/pycryptodome-3.9.4.tar.gz"
    sha256 "a168e73879619b467072509a223282a02c8047d932a48b74fbd498f27224aa04"
  end

  resource "reportlab" do
    url "https://files.pythonhosted.org/packages/9b/e0/97b334f0e6a805c921ac369a153cea6ea822787a1d8247c7e65b1386c520/reportlab-3.5.32.tar.gz"
    sha256 "83ef44936ef4e9c432d62bc2b72ec8d772b87af319d123e827a72e9b6884c851"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/29/e0/135df2e733790a3d3bcda970fd080617be8cea3bd98f411e76e6847c17ef/sortedcontainers-2.1.0.tar.gz"
    sha256 "974e9a32f56b17c1bac2aebd9dcf197f3eb9cd30553c5852a3187ad162e1a03a"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/cd/22/f15bb3c0a2810da0e825d193fb76d782015d82c676c4f682a957814926d7/tqdm-4.41.1.tar.gz"
    sha256 "4789ccbb6fc122b5a6a85d512e4e41fc5acad77216533a6f2b8ce51e0f265c23"
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
