class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/c5/47/ebd9cdc09d82462533f69f983c7f57ebbf01e68adb111a3c49acacde2540/PyMuPDF-1.23.26.tar.gz"
  sha256 "a904261b317b761b0aa2bd2c1f6cd25d25aa4258be67a90c02a878efc5dca649"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "77f2c4c73f3887392b5ce3cb25cb71e0f4d63db4cb7a65e999d527ec39b7ed62"
    sha256 cellar: :any,                 arm64_ventura:  "a99a7e90b4d6c8538bb1a86acb7bc2793df6da6930c20979a610f3b23634deb6"
    sha256 cellar: :any,                 arm64_monterey: "6915716f9fa7367a07c851c4f816319681b2b7189f989f79dcf5248fdaf8450f"
    sha256 cellar: :any,                 sonoma:         "0feec8e8de48b63cb1c73d62a203cc2524203c3f3a33859eaa37cc01111e4baf"
    sha256 cellar: :any,                 ventura:        "5652d5c744a45467bef96994326cd99dd697d1c12f4a8cf603cd0a5f6d71243a"
    sha256 cellar: :any,                 monterey:       "bf4c96de9650f5c9b0f63c729f90c78b05a177d58c6d9de9d6f8b87da1a5a1a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92b262015d957521210421c4780603572c37b3bbc6a49df00ac70c99da9b6b53"
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
