class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://github.com/jbarlow83/OCRmyPDF"
  url "https://files.pythonhosted.org/packages/03/f2/71cd4de6bdb1a9b2c415239c7f7ee271b3f4ad9f70d56197c74749088255/ocrmypdf-9.7.2.tar.gz"
  sha256 "9809a443067de3b41169790e3c109d1a37d803f1eecf62e33d44cfaefa07626f"
  revision 1

  bottle do
    cellar :any
    sha256 "238fffc8ede152a0a57a156b1c20b1e7587c7d5676debe65fd535cc058f22084" => :catalina
    sha256 "c5a8ff8659c15d0752f6a2360bc8313d29713a4c48791cda97f757969a9bdf93" => :mojave
    sha256 "47dea9d1eb8ce10c6e651b0e71e8be57ff23e2b714ce2ca63f23392e9b54ca21" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "jbig2enc"
  depends_on "jpeg"
  depends_on "leptonica"
  depends_on "libpng"
  depends_on "pngquant"
  depends_on "pybind11"
  depends_on "python@3.8"
  depends_on "qpdf"
  depends_on "tesseract"
  depends_on "unpaper"

  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/05/54/3324b0c46340c31b909fcec598696aaec7ddc8c18a63f2db352562d3354c/cffi-1.14.0.tar.gz"
    sha256 "2d384f4a127a15ba701207f7639d94106693b6cd64173d6c8988e2c25f3ac2b6"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "img2pdf" do
    url "https://files.pythonhosted.org/packages/f4/f8/0dff30a3bf2a46ebda2dc59c513b3384ee6320d16c242f512dba9fe427d6/img2pdf-0.3.4.tar.gz"
    sha256 "0b482b7f317b76051fabf6e50e5eea1584b20bdf76b6b54c16b6ef1d5298ee49"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/39/2b/0a66d5436f237aff76b91e68b4d8c041d145ad0a2cdeefe2c42f76ba2857/lxml-4.5.0.tar.gz"
    sha256 "8620ce80f50d023d414183bf90cc2576c2837b88e00bea3f33ad2630133bbb60"
  end

  resource "pdfminer.six" do
    url "https://files.pythonhosted.org/packages/7e/5c/005dacc83be82de399f20355e6deb89791d9b81d286e961730c8e85558f8/pdfminer.six-20200402.tar.gz"
    sha256 "dd163540391ac8b50c74f0c40f21b7c0a350591d72d516714aa198d103f306a3"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/ba/84/eff1f7803fa43614e139b30ecf3f7ccfdccaa23b73209535358c3b7f3a2c/pikepdf-1.11.1.tar.gz"
    sha256 "c6a061bab765134d74698f0ec0b9cdd231d95158716535d2518c9044291c0ffc"
  end

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/39/47/f28067b187dd664d205f75b07dcc6e0e95703e134008a14814827eebcaab/Pillow-7.0.0.tar.gz"
    sha256 "4d9ed9a64095e031435af120d3c910148067087541131e82b3e8db302f4c8946"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/69/2a/298b2689bee8e88c502c7e85ba1c9f07c7e182ea91c705c449f693056c9f/pycryptodome-3.9.7.tar.gz"
    sha256 "f1add21b6d179179b3c177c33d18a2186a09cc0d3af41ff5ed3f377360b869f2"
  end

  resource "reportlab" do
    url "https://files.pythonhosted.org/packages/74/0b/34dc83ed0108417358716d218eec8528b24c30597570a71cab929bce2432/reportlab-3.5.42.tar.gz"
    sha256 "9c21f202697a6cea57b9d716288fc919d99cbabeb30222eebfc7ff77eac32744"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/29/e0/135df2e733790a3d3bcda970fd080617be8cea3bd98f411e76e6847c17ef/sortedcontainers-2.1.0.tar.gz"
    sha256 "974e9a32f56b17c1bac2aebd9dcf197f3eb9cd30553c5852a3187ad162e1a03a"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/12/67/e736c012c6c8b4092dd54bb9bdd7737acf9a140a98c58b87c35363d0105d/tqdm-4.45.0.tar.gz"
    sha256 "00339634a22c10a7a22476ee946bbde2dbe48d042ded784e4d88e0236eca5d81"
  end

  def install
    venv = virtualenv_create(libexec, Formula["python@3.8"].bin/"python3")

    resource("Pillow").stage do
      inreplace "setup.py" do |s|
        sdkprefix = MacOS.sdk_path_if_needed ? MacOS.sdk_path : ""
        s.gsub! "openjpeg.h",
                "probably_not_a_header_called_this_eh.h"
        s.gsub! "ZLIB_ROOT = None",
                "ZLIB_ROOT = ('#{sdkprefix}/usr/lib', '#{sdkprefix}/usr/include')"
        s.gsub! "JPEG_ROOT = None",
                "JPEG_ROOT = ('#{Formula["jpeg"].opt_prefix}/lib', '#{Formula["jpeg"].opt_prefix}/include')"
        s.gsub! "FREETYPE_ROOT = None",
                "FREETYPE_ROOT = ('#{Formula["freetype"].opt_prefix}/lib', " \
                                 "'#{Formula["freetype"].opt_prefix}/include')"
      end

      # avoid triggering "helpful" distutils code that doesn't recognize Xcode 7 .tbd stubs
      unless MacOS::CLT.installed?
        ENV.append "CFLAGS", "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers"
      end
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
