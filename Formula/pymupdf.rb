class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://github.com/pymupdf/PyMuPDF"
  url "https://files.pythonhosted.org/packages/3e/06/bd008c25b210a13b8f7684d880fb7ae098d8bbbecabd6547932650a61fa0/PyMuPDF-1.22.3.tar.gz"
  sha256 "5ecd928e96e63092571020973aa145b57b75707f3a3df97c742e563112615891"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8b684e1fd800dcd214d61be3be5a216f8714e0217ff956deaf8f0488ea65e4d7"
    sha256 cellar: :any,                 arm64_monterey: "bd8fe1d4c332f26e9e0d5e9d075021663f0aa97313eb76731bb34018ef2cb532"
    sha256 cellar: :any,                 arm64_big_sur:  "e2c82f53e6c5e07d9a916163fa522ac13c6b1e3bb12f6553c3369bb3ae38ce6e"
    sha256 cellar: :any,                 ventura:        "84b5ece0dc4e50262daca3c964cf366f763779d10c66fc043ccc7be769f66999"
    sha256 cellar: :any,                 monterey:       "a893ea3f32e30840005183f2ebbfda8250f656a2af7fdb102b4c36bf0d333807"
    sha256 cellar: :any,                 big_sur:        "d2e0dfd0b9cd915957e2a054d6cd3a1f4de1f24105e326353658bb8645c471f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46b942a0e4f23cc2183ec03b5c176c80dc08d6c1671600cbc182e71405181265"
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
