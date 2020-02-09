class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://github.com/jbarlow83/OCRmyPDF"
  url "https://files.pythonhosted.org/packages/18/df/10630a3ba916ac9832c6c409a40b9186f6cd5a97570f70056bad9a8175ba/ocrmypdf-9.5.0.tar.gz"
  sha256 "6b8d5f8be690f6850fbe0e2a4d496f2ed92bc275ad8dad8fbb3f115c84ab87db"

  bottle do
    cellar :any
    sha256 "882e27dfcaf71d4c023025d2ffaa693aa47a7d961f5064f641aa180a5aa35e26" => :catalina
    sha256 "4026c4cce3371ac401f6a06256f35293099ad20b6da30ae0afabfa8b222adc18" => :mojave
    sha256 "783349f495b20c0049cbda54012269b36a376c334da11b36a4bfbac6a404cd40" => :high_sierra
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
    url "https://files.pythonhosted.org/packages/39/2b/0a66d5436f237aff76b91e68b4d8c041d145ad0a2cdeefe2c42f76ba2857/lxml-4.5.0.tar.gz"
    sha256 "8620ce80f50d023d414183bf90cc2576c2837b88e00bea3f33ad2630133bbb60"
  end

  resource "pdfminer.six" do
    url "https://files.pythonhosted.org/packages/9f/c0/4a106c354cff69c6946aab857766616e72208d7cce0ad3e78aa356c6d34c/pdfminer.six-20200124.tar.gz"
    sha256 "9f34f8f61cd72ae23ef572e0ea1c93cd2b1e4a6d1137d14ed23763b5b2094e13"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/38/9e/07dd2e45436c6282d7efb3de0d561a07926048a5cbda9489a3bb8abd08b7/pikepdf-1.10.0.tar.gz"
    sha256 "5099c256cc0143801ea06a935c954fc833e4f595759c3239e6f4ed19aad244e1"
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
    url "https://files.pythonhosted.org/packages/37/84/5bb86e0a4cda99669ccf0814942889499dc11e3124fd4cc2f4faa447e966/pycryptodome-3.9.6.tar.gz"
    sha256 "bc22ced26ebc46546798fa0141f4418f1db116dec517f0aeaecec87cf7b2416c"
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
    url "https://files.pythonhosted.org/packages/c3/31/e6505e9ed53fbffc82c72b8f598f3f883f27f3a186855097a75149b9c62f/tqdm-4.42.0.tar.gz"
    sha256 "5865f5fef9d739864ff341ddaa69894173ebacedb1aaafcf014de56343d01d5c"
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
