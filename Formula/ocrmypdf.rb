class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://github.com/jbarlow83/OCRmyPDF"
  url "https://files.pythonhosted.org/packages/4d/13/a9969946ee6a02a3dfc89fb487b8039bd93940036c43715f35760beb18eb/ocrmypdf-9.7.1.tar.gz"
  sha256 "fd029b97463e054d95eed361843397a76b2aa35913ac96c57cf8c15a15411971"
  revision 1

  bottle do
    cellar :any
    sha256 "3fcc1397b1eedc69d4872b597b0a14aebc3bf550d137f798ff7b7fb7c65f00f2" => :catalina
    sha256 "038db0d1ca8d6ddd2cfbcbcbed57b02096250262a77d4b744f342981aa944d78" => :mojave
    sha256 "bf76f8525db807654dec27f1e45790fc4612a7198be9ad40e69d98c4de91d0bf" => :high_sierra
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
    url "https://files.pythonhosted.org/packages/e0/c6/7cd14232a1b10bf884c12daf3626afb76c4f60b52ae0eb23ce1519542ae4/img2pdf-0.3.3.tar.gz"
    sha256 "9d77c17ee65a736abe92ef8cba9cca009c064ea4ed74492c01aea596e41856cf"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/39/2b/0a66d5436f237aff76b91e68b4d8c041d145ad0a2cdeefe2c42f76ba2857/lxml-4.5.0.tar.gz"
    sha256 "8620ce80f50d023d414183bf90cc2576c2837b88e00bea3f33ad2630133bbb60"
  end

  resource "pdfminer.six" do
    url "https://files.pythonhosted.org/packages/9f/c0/4a106c354cff69c6946aab857766616e72208d7cce0ad3e78aa356c6d34c/pdfminer.six-20200124.tar.gz"
    sha256 "9f34f8f61cd72ae23ef572e0ea1c93cd2b1e4a6d1137d14ed23763b5b2094e13"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/96/6b/fa2619a014453b67c3152222a1fdaeda84d6ce30dd9bf799760fe6946456/pikepdf-1.11.0.tar.gz"
    sha256 "bad914a8b1d9be0a7451feba29f25dbc47e14aed85fdb11bfa1b3405a3ca3a6d"
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
    url "https://files.pythonhosted.org/packages/0f/0b/bce8f4a6641c30889fd82b50665f0f7521d633bfd3360af2c11b8b2200af/reportlab-3.5.34.tar.gz"
    sha256 "9675a26d01ec141cb717091bb139b6227bfb3794f521943101da50327bff4825"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/29/e0/135df2e733790a3d3bcda970fd080617be8cea3bd98f411e76e6847c17ef/sortedcontainers-2.1.0.tar.gz"
    sha256 "974e9a32f56b17c1bac2aebd9dcf197f3eb9cd30553c5852a3187ad162e1a03a"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/7a/cf/625e53bb8c6ad88302192c7aa50d45cdfb2b0fe97892869ec3dd9309f67f/tqdm-4.43.0.tar.gz"
    sha256 "f35fb121bafa030bd94e74fcfd44f3c2830039a2ddef7fc87ef1c2d205237b24"
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
