class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://github.com/pymupdf/PyMuPDF"
  url "https://files.pythonhosted.org/packages/28/ba/d6bb6fd678e8396d7b944870286fb25fd6f499b8cb599b5436c8f725adbf/PyMuPDF-1.22.0.tar.gz"
  sha256 "6e1694e5c0cd8b92d503a506ee8e4ba1bed768528de586889d3ec90e9dc4a7d3"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "40ffd7eafef12bf4dd30ec1caf534e8ddb0413a68cecfded434d7ca3f1eb2d46"
    sha256 cellar: :any,                 arm64_monterey: "0cf0c71c9d708564c6caed5a9d0714a94a4ffd4f970ba0ff8b99c05b518049dd"
    sha256 cellar: :any,                 arm64_big_sur:  "504a61b2362b2a20c145f6e1a3fbafb52ebe00db1bcd682fd09fd9394d4728ad"
    sha256 cellar: :any,                 ventura:        "7802a030851c6e7c4f9907b2b15203aaba030012e67cf6b8fd703b04e43d1e5d"
    sha256 cellar: :any,                 monterey:       "8a14f13294c641b27f8e186bfa9bdd7d9ca2975e77f1eba07942c5c3c2ad46e7"
    sha256 cellar: :any,                 big_sur:        "651859820a7363624201ef50ec0b5eeb0c49f3cc0c320e83cebf9b8f0e084a47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fc828f5ead0ebbe8d4d0be5cb66ebdb141d6ab3a6d098fc7deb7cc8aa38cc34"
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
