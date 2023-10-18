class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://github.com/pymupdf/PyMuPDF"
  url "https://files.pythonhosted.org/packages/f6/6a/199e6b76f1cca112510171df0949af1fcf43536812441866e7c9e1d7b01e/PyMuPDF-1.22.5.tar.gz"
  sha256 "5ec8d5106752297529d0d68d46cfc4ce99914aabd99be843f1599a1842d63fe9"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5405de418b086d7cb1cad6c9099d8172a3709f5a9e7556a7c79e0bb7460215b3"
    sha256 cellar: :any,                 arm64_ventura:  "e344a0f43c186b16265d59eb060279cab06f6616ec1bf6012acc2136fabcd94a"
    sha256 cellar: :any,                 arm64_monterey: "88e71210e6af9f6c5da4c75c01e498ae9ed4204b1432497ae309130c71054697"
    sha256 cellar: :any,                 arm64_big_sur:  "1ed8350b7ed5247b64d7921a612fc8958801445aec5446372ea25648418329f4"
    sha256 cellar: :any,                 sonoma:         "81f016fbec0e67c89c40b5a5d8f1e1087850e1202a5bca52cb8b4d264b18ded0"
    sha256 cellar: :any,                 ventura:        "e1fef6b977cf7f6ca6cee0fb0507e87b036b314e087461dba32e0624595d2972"
    sha256 cellar: :any,                 monterey:       "c8e3e20c9c919adbe51131e9e54a2fa04a3a37bdd0e22a664d207bdc96042807"
    sha256 cellar: :any,                 big_sur:        "b08f15abb4d746f6482da519605be8779651d9d89daf49da28e83ebf2e79ffbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "779784af438161aa105c9338e988da7fd22e92ce6b7537bd94aa037daceedd3d"
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

    system python3, "-m", "pip", "install", *std_pip_args, "."
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
