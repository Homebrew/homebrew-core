class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/05/20/a0d1221d8f379afcc12b4d1687a8f4adb69eef659e835d781c3fa331ff46/PyMuPDF-1.23.22.tar.gz"
  sha256 "c41cd91d83696cea67a4b6c65cc1951c2019ac0a561c5a3f543318ede30d3cd0"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "28de1cbd13b92f8c5ebf6842e09290eb331555ddeadd0c70412c9ab230ed6db1"
    sha256 cellar: :any,                 arm64_ventura:  "5eb4473a6cbfaaa77adb2a4718b92bea1428af2069c874a3923c916f69d45446"
    sha256 cellar: :any,                 arm64_monterey: "6e4acab6b1522079a3b55224f0769b96de66ed9f795b705e01d452605f8a4b7c"
    sha256 cellar: :any,                 sonoma:         "7c8930019cb344fd690e28869f0690d434224f5eb3b96d7aabe52b698d67c9a9"
    sha256 cellar: :any,                 ventura:        "6941499b2bcc9090c552b4b6f63eacc23660ac62d701291d7dfd2dd66f9ee72e"
    sha256 cellar: :any,                 monterey:       "61b206c75ea89146f5c5a1998b7c3239c39859d8fbfa73802b453122f8ff6c77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a18aa40d3202967d524359427c5d0fc48fd5907e481d8c5bdb86582c667aba8c"
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
