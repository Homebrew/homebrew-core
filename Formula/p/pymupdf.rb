class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/1b/0c/40dda0cc4bd2220a2ef75f8c53dd7d8ed1e29681fcb3df75db6ee9677a7e/pymupdf-1.27.1.tar.gz"
  sha256 "4afbde0769c336717a149ab0de3330dcb75378f795c1a8c5af55c1a628b17d55"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "95d4c047aa1d9cd6a80ea2783c8369fe0e322b1fee74dbac2a47b3a6dc473290"
    sha256 cellar: :any,                 arm64_sequoia: "dc3a372c99f476c6bda479895d690efc2ffd6a1fb3e63604c12dbc1bbbb6e3e2"
    sha256 cellar: :any,                 arm64_sonoma:  "2c6d6e3645a2c41f6210ec5064c0f1495cfeaf321556a0826570198e151c2d01"
    sha256 cellar: :any,                 sonoma:        "aab8d5207c7039cf17681e6d9f68038699bed7878b060ad02542d903ca738f46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e14b5c8327592b18ee132316856f9e0527076070f95a0cd0507ac2dc316ce3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "139a5f7e212a6519dbed97628155639f462428e324d40ca0f309f0c2b59775af"
  end

  depends_on "freetype" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "mupdf"
  depends_on "python@3.14"

  def python3
    "python3.14"
  end

  def install
    # Makes setup skip build stage for mupdf
    # https://github.com/pymupdf/PyMuPDF/blob/1.20.0/setup.py#L447
    ENV["PYMUPDF_SETUP_MUPDF_BUILD"] = ""
    ENV["PYMUPDF_INCLUDES"] = "#{Formula["mupdf"].opt_include}:#{Formula["freetype"].opt_include}/freetype2"

    mupdf_libpath = Formula["mupdf"].opt_lib.to_s
    ENV["PYMUPDF_MUPDF_LIB"] = mupdf_libpath
    ENV.append "LDFLAGS", "-Wl,-rpath,#{mupdf_libpath}" if OS.mac?

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath/"test.py").write <<~PYTHON
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
    PYTHON

    in_pdf = test_fixtures("test.pdf")
    out_png = testpath/"test.png"

    system python3, testpath/"test.py", in_pdf, out_png
    assert_path_exists out_png
  end
end
