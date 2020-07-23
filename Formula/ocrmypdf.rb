class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://github.com/jbarlow83/OCRmyPDF"
  url "https://files.pythonhosted.org/packages/1b/9b/f0bf749d3c952fc25bf4b01b068f1c04f979fc880e10f2cc236b51a24716/ocrmypdf-10.3.0.tar.gz"
  sha256 "e7a92ce59b1c53cb1738af1e55c9683de36ebea864d5c9c9ab670c7c9ce0944b"
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
    url "https://files.pythonhosted.org/packages/2c/4d/3ec1ea8512a7fbf57f02dee3035e2cce2d63d0e9c0ab8e4e376e01452597/lxml-4.5.2.tar.gz"
    sha256 "cdc13a1682b2a6241080745b1953719e7fe0850b40a5c71ca574f090a1391df6"
  end

  resource "pdfminer.six" do
    url "https://files.pythonhosted.org/packages/62/d1/d5132e95f0e708de344d69eef8309aadd21721a5d12b5770c120a2225797/pdfminer.six-20200517.tar.gz"
    sha256 "429a099d2ca76cedff79652e17cfc37d7751a26d50f30af0fa791a69f68a3ddc"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/3f/29/1ed262c3783f2b3714dc9fe044b1b82d392465fb0c20ef6f0e8ed6f8986d/pikepdf-1.17.2.tar.gz"
    sha256 "fb65004b46b377d5add1c76d249d05759ef2201fb772a7676afcdf9d84da4c94"
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

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/4c/2b/eddbfc56076fae8deccca274a5c70a9eb1e0b334da0a33f894a420d0fe93/pycryptodome-3.9.8.tar.gz"
    sha256 "0e24171cf01021bc5dc17d6a9d4f33a048f09d62cc3f62541e95ef104588bda4"
  end

  resource "reportlab" do
    url "https://files.pythonhosted.org/packages/52/09/85beb77f215bf47de07d2041731bdba55d7290a9304daad2eda935d3337f/reportlab-3.5.46.tar.gz"
    sha256 "56d71b78e7e4bb31a93e1dff13c22d19b7fb3890b021a39b6c3661b095bd7de8"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/3b/fb/48f6fa11e4953c530b09fa0f2976df5234b0eaabcd158625c3e73535aeb8/sortedcontainers-2.2.2.tar.gz"
    sha256 "4e73a757831fc3ca4de2859c422564239a31d8213d09a2a666e375807034d2ba"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/71/6c/6530032ec26dddd47bb9e052781bcbbcaa560f05d10cdaf365ecb990d220/tqdm-4.48.0.tar.gz"
    sha256 "6baa75a88582b1db6d34ce4690da5501d2a1cb65c34664840a456b2c9f794d29"
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
