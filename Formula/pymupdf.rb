class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://github.com/pymupdf/PyMuPDF"
  url "https://files.pythonhosted.org/packages/30/44/9fce79689e5df7deebe2d17cb2b9b2a6b888439c241e71296e732aefa649/PyMuPDF-1.21.1.tar.gz"
  sha256 "f815741a435c62a0036bbcbf5fa6c533567bd69c5338d413714fc57b22db93e0"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8bc9eba5fb8bb3f3d10950518bf7e59128a0055fc54ce1d44e4217a96d2c4de4"
    sha256 cellar: :any,                 arm64_monterey: "b5ddcc91c1a7f61f4892a0faedf8705a40e964c21768f5a003d20c3ea6fd5883"
    sha256 cellar: :any,                 arm64_big_sur:  "8f9397042a6c515b13167dacc98d120db10bb927414b44f939fadac0cb1c4fcf"
    sha256 cellar: :any,                 ventura:        "6dfbc154a712d4bc577dd75ca54d93d8c26f521bd3cf4359847ba8dcabb71c5f"
    sha256 cellar: :any,                 monterey:       "511cb6b6318808f17c5e7b2d0193787cab690988ae71f11468bc95d160a02016"
    sha256 cellar: :any,                 big_sur:        "6147f4ce4ac89f2f490715e1be1767119bcb5f61f7235b9bc0d6b87d3d5cc06a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a28c16eb94fae965241b3adbb2d55de329edbdcb4becd2ac35f925f7c9b9cca"
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
