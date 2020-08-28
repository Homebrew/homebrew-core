class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://github.com/jbarlow83/OCRmyPDF"
  url "https://files.pythonhosted.org/packages/03/27/a1d9147b8d4feed8d3de1eb4c0c6c16a15ff6820e2fa57a72fa1977fb111/ocrmypdf-11.0.1.tar.gz"
  sha256 "26600d326eb0e12c45fa96f48955021adf90a25e0bfc800e6f10c1d780c5c36a"
  license "MPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "1a138523edd74db5503a0a21a1ddce66843103804549dc67e826b7e385517a42" => :catalina
    sha256 "8bf7da6ffd84e5583444f544576f255484296e0277b143e037e6e0ae87063270" => :mojave
    sha256 "7a7559619ab015d28b214465136a3687825e5dd6ab6c8a8925293c800774eeb9" => :high_sierra
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
    url "https://files.pythonhosted.org/packages/f7/09/88bbe20b76ca76be052c366fe77aa5e3cd6e5f932766e5597fecdd95b2a8/cffi-1.14.2.tar.gz"
    sha256 "ae8f34d50af2c2154035984b8b5fc5d9ed63f32fe615646ab435b05b132ca91b"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "coloredlogs" do
    url "https://files.pythonhosted.org/packages/84/1b/1ecdd371fa68839cfbda15cc671d0f6c92d2c42688df995a9bf6e36f3511/coloredlogs-14.0.tar.gz"
    sha256 "a1fab193d2053aa6c0a97608c4342d031f1f93a3d1218432c59322441d31a505"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/bf/ac/552fc8729d90393845cc3a2062facf4a89dcbe206fa78771d60ddaae7554/cryptography-3.0.tar.gz"
    sha256 "8e924dbc025206e97756e8903039662aa58aa9ba357d8e1d8fc29e3092322053"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/6c/19/8e3b4c6fa7cca4788817db398c05274d98ecc6a35e0eaad2846fde90c863/humanfriendly-8.2.tar.gz"
    sha256 "bf52ec91244819c780341a3438d5d7b09f431d3f113a475147ac9b7b167a3d12"
  end

  resource "img2pdf" do
    url "https://files.pythonhosted.org/packages/80/ed/5167992abaf268f5a5867e974d9d36a8fa4802800898ec711f4e1942b4f5/img2pdf-0.4.0.tar.gz"
    sha256 "eaee690ab8403dd1a9cb4db10afee41dd3e6c7ed63bdace02a0121f9feadb0c9"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/2c/4d/3ec1ea8512a7fbf57f02dee3035e2cce2d63d0e9c0ab8e4e376e01452597/lxml-4.5.2.tar.gz"
    sha256 "cdc13a1682b2a6241080745b1953719e7fe0850b40a5c71ca574f090a1391df6"
  end

  resource "pdfminer.six" do
    url "https://files.pythonhosted.org/packages/34/4a/bc38040c4a970870ccbef975bae2b6b1bccaa2d308e61111203cccc58e89/pdfminer.six-20200726.tar.gz"
    sha256 "8513b27d780ac83e8474cef245c43d1ebf65ca9550dc07ac0525b4d47eb2c310"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/1f/09/4b374a0d0bf1750e18a005c77be62cf5148a7b87535ffb2c20670c5fcc5f/pikepdf-1.19.0.tar.gz"
    sha256 "7eeff4fee3080cbe938480ca35a5e1f813e7ff221277124c6f9d8cc2d6e44b62"
  end

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/3e/02/b09732ca4b14405ff159c470a612979acfc6e8645dc32f83ea0129709f7a/Pillow-7.2.0.tar.gz"
    sha256 "97f9e7953a77d5a70f49b9a48da7776dc51e9b738151b22dacf101641594a626"
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
    url "https://files.pythonhosted.org/packages/33/24/f12ff0143b9251ffcd930a8516ea59c7ea5048feb3a7bde66cf6354a5f15/reportlab-3.5.48.tar.gz"
    sha256 "0bfe3fe6e1bd1d922f83683eae2ba1d2d29de94e25fb115eacca9530b4b02f76"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/3b/fb/48f6fa11e4953c530b09fa0f2976df5234b0eaabcd158625c3e73535aeb8/sortedcontainers-2.2.2.tar.gz"
    sha256 "4e73a757831fc3ca4de2859c422564239a31d8213d09a2a666e375807034d2ba"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/7c/a2/4cc95d7766a5d17ea2541d88da357d5905f75b6dbdfd17dfffd6c37647ae/tqdm-4.48.2.tar.gz"
    sha256 "564d632ea2b9cb52979f7956e093e831c28d441c11751682f84c86fc46e4fd21"
  end

  def install
    venv = virtualenv_create(libexec, Formula["python@3.8"].bin/"python3")

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
