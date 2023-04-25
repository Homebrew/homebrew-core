class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://github.com/pymupdf/PyMuPDF"
  url "https://files.pythonhosted.org/packages/79/fc/9dd8f019a9a3e589682237b2612d0e9c6a4ffbeb038c0783ccb83a415c4a/PyMuPDF-1.22.1.tar.gz"
  sha256 "ad34bba78ce147cee50e1dc30fa16f29135a4c3d6a2b1c1b0403ebbcc9fbe4be"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a6fc1f0cf364f61651cdbc387ede728dcf94373459fee7ce267578609598ff1b"
    sha256 cellar: :any,                 arm64_monterey: "c3b0b4d7382f8baf8c5250a45c3399342e8e2b4cfe537d83b03b5925ff72c9eb"
    sha256 cellar: :any,                 arm64_big_sur:  "f40b6fa7baa09ca7adc025dce415f9be37fa1c8f805752578c00d6c7740d2140"
    sha256 cellar: :any,                 ventura:        "474e3eda5becec62323201d43504faeaf50bc77445bcdc564eb578989cd913a5"
    sha256 cellar: :any,                 monterey:       "3301d60fa9e9a826ebce3a399b607b60717e12d305bf6f6a3e9682ca046d6cbb"
    sha256 cellar: :any,                 big_sur:        "e14ea14f1c245d417d20ed786192e7cd3d9707226b16a2678240c3fbc869a75c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44ee8a43fe69d22321ed1105380d2be004f8e9dc081aa19e87b2cfc2c3e70bca"
  end

  depends_on "freetype" => :build
  depends_on "swig" => :build

  depends_on "mupdf"
  depends_on "python@3.11"

  on_linux do
    depends_on "gumbo-parser"
    depends_on "harfbuzz"
    depends_on "jbig2dec"
    depends_on "mujs"
    depends_on "openjpeg"
  end

  def python3
    "python3.11"
  end

  def install
    # Fix hardcoded paths so they work on Linux and non-default prefixes.
    inreplace "setup.py" do |s|
      s.gsub! "/usr/local", HOMEBREW_PREFIX
      s.gsub! %r{/usr(?!/local)}, HOMEBREW_PREFIX
    end

    # Makes setup skip build stage for mupdf
    # https://github.com/pymupdf/PyMuPDF/blob/1.20.0/setup.py#L447
    ENV["PYMUPDF_SETUP_MUPDF_BUILD"] = ""

    system python3, *Language::Python.setup_install_args(prefix, python3), "build"
  end

  test do
    (testpath/"test.py").write <<~EOS
      import sys
      from pathlib import Path

      import fitz

      in_pdf = sys.argv[1]
      out_png = sys.argv[2]

      # Convert first page to PNG
      pdf_doc = fitz.open(in_pdf)
      pdf_page = pdf_doc.load_page(0)
      png_bytes = pdf_page.get_pixmap().tobytes()

      Path(out_png).write_bytes(png_bytes)
    EOS

    in_pdf = test_fixtures("test.pdf")
    out_png = testpath/"test.png"

    system python3, testpath/"test.py", in_pdf, out_png
    assert_predicate out_png, :exist?
  end
end
