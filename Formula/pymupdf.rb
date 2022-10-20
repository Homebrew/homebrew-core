class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://github.com/pymupdf/PyMuPDF"
  url "https://files.pythonhosted.org/packages/4a/09/6afe87a8ea7acb6e4709223a704270ffe9929497add4d06b12305e229ba8/PyMuPDF-1.20.2.tar.gz"
  sha256 "02eedf01f57c6bafb5e8667cea0088a2d2522643c47100f1908bec3a68a84888"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "040b53594f1f9e082ea22aa3031b70e9bce85771db4898f20e8d620cee90ce9c"
    sha256 cellar: :any,                 arm64_big_sur:  "982c82003dd5479647f53972984d9a79434845d06cc44aa089a7f42eb9626c6c"
    sha256 cellar: :any,                 monterey:       "3d2061b48c2acc155878904c90ce684972b05c801286db291f43c8ff2dd105e9"
    sha256 cellar: :any,                 big_sur:        "123c9c70094da62c6b329c0fddd1321f560ef231e9a5ae1b882e2a020ab979ca"
    sha256 cellar: :any,                 catalina:       "768ea5353e7f4e3729ff6c22acac3a0cb9a2e305bd74e4a147eb84ddea6aceff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2b9dd7e07509785cba7e00e2c7cf6b950ef3259ae4e7c258d68ab2a6d03c9b5"
  end

  depends_on "freetype" => :build
  depends_on "swig" => :build

  depends_on "mupdf"
  depends_on "python@3.10"

  on_linux do
    depends_on "gumbo-parser"
    depends_on "harfbuzz"
    depends_on "jbig2dec"
    depends_on "mujs"
    depends_on "openjpeg"
  end

  def python3
    "python3.10"
  end

  def install
    if OS.linux?
      ENV.append_path "CPATH", Formula["mupdf"].include/"mupdf"
      ENV.append_path "CPATH", Formula["freetype2"].include/"freetype2"
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
