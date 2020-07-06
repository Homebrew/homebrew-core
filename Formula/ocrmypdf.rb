class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://github.com/jbarlow83/OCRmyPDF"
  url "https://files.pythonhosted.org/packages/4e/bb/35a55dfaf1b5df31fccef7276362515e4eaea5ca1f37a853cfe46273196b/ocrmypdf-10.2.0.tar.gz"
  sha256 "eb9defb761ff221e3cf724823772dc7495db9bb4bf1aca9b4312b1b4bc583cd7"
  license "GPL-3.0"

  bottle do
    cellar :any
    sha256 "517262a5bc1e7798ec806bef42fd76f798ca18ef42b9fa4b76dfbefc3e1585f3" => :catalina
    sha256 "7d33c1954df20a093cf26ef72b480ddda4e98ca6139b208cc135d875f7e15e2c" => :mojave
    sha256 "49f6e8246090a26c0ab52fe5221981bd04f937a156ad45c17c71387543fd2e50" => :high_sierra
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

  resource "coloredlogs" do
    url "https://files.pythonhosted.org/packages/84/1b/1ecdd371fa68839cfbda15cc671d0f6c92d2c42688df995a9bf6e36f3511/coloredlogs-14.0.tar.gz"
    sha256 "a1fab193d2053aa6c0a97608c4342d031f1f93a3d1218432c59322441d31a505"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/6c/19/8e3b4c6fa7cca4788817db398c05274d98ecc6a35e0eaad2846fde90c863/humanfriendly-8.2.tar.gz"
    sha256 "bf52ec91244819c780341a3438d5d7b09f431d3f113a475147ac9b7b167a3d12"
  end

  resource "img2pdf" do
    url "https://files.pythonhosted.org/packages/65/12/6ee1a77614df6decefd88f781cf95b73acf93f0cc9eb03bd5042d116b85d/img2pdf-0.3.6.tar.gz"
    sha256 "8cd5509a60b75f4442b897bad3d593e25ebd314105f3034a8f17def396a4a0fb"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/03/a8/73d795778143be51d8b86750b371b3efcd7139987f71618ad9f4b8b65543/lxml-4.5.1.tar.gz"
    sha256 "27ee0faf8077c7c1a589573b1450743011117f1aa1a91d5ae776bbc5ca6070f2"
  end

  resource "pdfminer.six" do
    url "https://files.pythonhosted.org/packages/62/d1/d5132e95f0e708de344d69eef8309aadd21721a5d12b5770c120a2225797/pdfminer.six-20200517.tar.gz"
    sha256 "429a099d2ca76cedff79652e17cfc37d7751a26d50f30af0fa791a69f68a3ddc"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/d2/22/6f77d3112ce7b1f25d4013e7a94fbb627938f5d297c7d4e9118a1e50792b/pikepdf-1.15.1.tar.gz"
    sha256 "59c3ff9251752e740b8863d5bb327d4fb598afa336db9e2b6038e7beb0fd57a5"
  end

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/ce/ef/e793f6ffe245c960c42492d0bb50f8d14e2ba223f1922a5c3c81569cec44/Pillow-7.1.2.tar.gz"
    sha256 "a0b49960110bc6ff5fead46013bcb8825d101026d466f3a4de3476defe0fb0dd"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f8/04/7a8542bed4b16a65c2714bf76cf5a0b026157da7f75e87cc88774aa10b14/pluggy-0.13.1.tar.gz"
    sha256 "15b2acde666561e1298d71b523007ed7364de07029219b604cf808bfa1c765b0"
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
    url "https://files.pythonhosted.org/packages/3b/fb/48f6fa11e4953c530b09fa0f2976df5234b0eaabcd158625c3e73535aeb8/sortedcontainers-2.2.2.tar.gz"
    sha256 "4e73a757831fc3ca4de2859c422564239a31d8213d09a2a666e375807034d2ba"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a9/03/df1d77e852dd697c0ff7b7b1b9888739517e5f97dfbd2cf7ebd13234084c/tqdm-4.46.1.tar.gz"
    sha256 "cd140979c2bebd2311dfb14781d8f19bd5a9debb92dcab9f6ef899c987fcf71f"
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
