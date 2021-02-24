class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://github.com/jbarlow83/OCRmyPDF"
  url "https://files.pythonhosted.org/packages/3b/6f/b35629fe70cd059f5c503e544d9857b94b91ed58b50e291a34a7f0d3813b/ocrmypdf-11.6.2.tar.gz"
  sha256 "0f624456a50be0b0bc8c0b59704d159f637616c093a1cabe8bb383706561bcf7"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any, big_sur:  "5f1ebe7f6f57f4287d08396519d61876b9f66ed91e71708572ecf0db5e6a2c2e"
    sha256 cellar: :any, catalina: "4346d71f5f395c289454aa5a9c0fd4295bf3ebef6fb779976c24521c1f41ef1a"
    sha256 cellar: :any, mojave:   "1f71d0c633234663731280dd4055f9bfe26f606897d653481a100908e04e1fac"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "jbig2enc"
  depends_on "jpeg"
  depends_on "leptonica"
  depends_on "libffi"
  depends_on "libpng"
  depends_on "pngquant"
  depends_on "pybind11"
  depends_on "python@3.9"
  depends_on "qpdf"
  depends_on "tesseract"
  depends_on "unpaper"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a8/20/025f59f929bbcaa579704f443a438135918484fffaacfaddba776b374563/cffi-1.14.5.tar.gz"
    sha256 "fd78e5fee591709f32ef6edb9a015b4aa1a5022598e36227500c8f4e02328d9c"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "coloredlogs" do
    url "https://files.pythonhosted.org/packages/ce/ef/bfca8e38c1802896f67045a0c9ea0e44fc308b182dbec214b9c2dd54429a/coloredlogs-15.0.tar.gz"
    sha256 "5e78691e2673a8e294499e1832bb13efcfb44a86b92e18109fa18951093218ab"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/60/6d/b32368327f600a12e59fb51a904fc6200dd7e65e953fd6fc6ae6468e3423/cryptography-3.4.5.tar.gz"
    sha256 "4f6761a82b51fe02cda8f45af1c2f698a10f50003dc9c2572d8a49eda2e6d35b"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/31/0e/a2e882aaaa0a378aa6643f4bbb571399aede7dbb5402d3a1ee27a201f5f3/humanfriendly-9.1.tar.gz"
    sha256 "066562956639ab21ff2676d1fda0b5987e985c534fc76700a19bd54bcb81121d"
  end

  resource "img2pdf" do
    url "https://files.pythonhosted.org/packages/80/ed/5167992abaf268f5a5867e974d9d36a8fa4802800898ec711f4e1942b4f5/img2pdf-0.4.0.tar.gz"
    sha256 "eaee690ab8403dd1a9cb4db10afee41dd3e6c7ed63bdace02a0121f9feadb0c9"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/db/f7/43fecb94d66959c1e23aa53d6161231dca0e93ec500224cf31b3c4073e37/lxml-4.6.2.tar.gz"
    sha256 "cd11c7e8d21af997ee8079037fff88f16fda188a9776eb4b81c7e4c9c0a7d7fc"
  end

  resource "pdfminer.six" do
    url "https://files.pythonhosted.org/packages/d8/bb/45cb24e715d3058f92f703265e6ed396767b19fec6d19d1ea54e04b730b7/pdfminer.six-20201018.tar.gz"
    sha256 "b9aac0ebeafb21c08bf65f2039f4b2c5f78a3449d0a41df711d72445649e952a"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/9c/a4/29b68c54886a1ce0cac3b7f8c65ef11ba2b50acf21e2dbefe29328edbefa/pikepdf-2.5.2.tar.gz"
    sha256 "8fc3e97b24dafbd4b1ac057c8f144c18467ce55d342a1a8c42688890ead58ef3"
  end

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/73/59/3192bb3bc554ccbd678bdb32993928cb566dccf32f65dac65ac7e89eb311/Pillow-8.1.0.tar.gz"
    sha256 "887668e792b7edbfb1d3c9d8b5d8c859269a0f0eba4dda562adb95500f60dbba"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f8/04/7a8542bed4b16a65c2714bf76cf5a0b026157da7f75e87cc88774aa10b14/pluggy-0.13.1.tar.gz"
    sha256 "15b2acde666561e1298d71b523007ed7364de07029219b604cf808bfa1c765b0"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "reportlab" do
    url "https://files.pythonhosted.org/packages/87/42/770d5815606aebb808344c9d90f96f95474b7d87047fba68fc282639db2c/reportlab-3.5.59.tar.gz"
    sha256 "a755cca2dcf023130b03bb671670301a992157d5c3151d838c0b68ef89894536"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/14/10/6a9481890bae97da9edd6e737c9c3dec6aea3fc2fa53b0934037b35c89ea/sortedcontainers-2.3.0.tar.gz"
    sha256 "59cc937650cf60d677c16775597c89a960658a09cf7c1a668f86e1e4464b10a1"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/d4/2a/99ac62cb012d81ffd96a2ddd9eba54d942c56f9244feb58b6a9a49d547d8/tqdm-4.56.2.tar.gz"
    sha256 "11d544652edbdfc9cc41aa4c8a5c166513e279f3f2d9f1a9e1c89935b51de6ff"
  end

  def install
    venv = virtualenv_create(libexec, Formula["python@3.9"].bin/"python3")

    resource("Pillow").stage do
      inreplace "setup.py" do |s|
        sdkprefix = MacOS.sdk_path_if_needed ? MacOS.sdk_path : ""
        s.gsub! "openjpeg.h", "probably_not_a_header_called_this_eh.h"
        s.gsub! "xcb.h", "probably_not_a_header_called_this_eh.h"
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
