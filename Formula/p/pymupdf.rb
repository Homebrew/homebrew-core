class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/51/48/cc0e4c32556e06bb8eb07a3f3553d940d198bf62f1abf528fb414993e43d/PyMuPDF-1.23.23.tar.gz"
  sha256 "f9931952b9e86b0edcd03aadaae71aa863d680680f7e2b2710814c71adab91bc"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5dba0fe5829417c78f4b6cd5f8be33542b5b0744456472f36395227c0fcbfd41"
    sha256 cellar: :any,                 arm64_ventura:  "35014a215a01732c1794d96946e57704978d266cee69bc92c58695c98baf5e6b"
    sha256 cellar: :any,                 arm64_monterey: "b80562f3c2812595ec55d29d1ed23dbdae479dad55da6dd098ba25d0acfa75cb"
    sha256 cellar: :any,                 sonoma:         "a738750a49632c0769bd141f3bd87082a68ef342f016fddd7ae8ce4f0981c64a"
    sha256 cellar: :any,                 ventura:        "e19260c413e02e7bc27cebe792f76273a00ceb0c5c01e6d3c5fc7e60c88aef6e"
    sha256 cellar: :any,                 monterey:       "8c73e9b998ca4e4703d09e61975b19d6a4e659a9c880a7ada9d28e58290ecb19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b5bfc488ee7cf6af5dabb721def63ae8480a16fef9715be12331ad95ee6ea92"
  end

  depends_on "freetype" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build

  depends_on "mupdf"
  depends_on "python@3.12"

  on_linux do
    depends_on "gumbo-parser"
    depends_on "harfbuzz"
    depends_on "jbig2dec"
    depends_on "mujs"
    depends_on "openjpeg"
  end

  def python3
    "python3.12"
  end

  def install
    # Makes setup skip build stage for mupdf
    # https://github.com/pymupdf/PyMuPDF/blob/1.20.0/setup.py#L447
    ENV["PYMUPDF_SETUP_MUPDF_BUILD"] = ""
    # Builds only classic implementation
    # https://github.com/pymupdf/PyMuPDF/issues/2628
    ENV["PYMUPDF_SETUP_IMPLEMENTATIONS"] = "a"
    ENV["PYMUPDF_INCLUDES"] = "#{Formula["mupdf"].opt_include} -I#{Formula["freetype"].opt_include}/freetype2"
    ENV["PYMUPDF_MUPDF_LIB"] = Formula["mupdf"].opt_lib.to_s

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath/"test.py").write <<~EOS
      import sys
      from pathlib import Path

      # per 1.23.9 release, `fitz` module got renamed to `fitz_old`
      import fitz_old as fitz

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
