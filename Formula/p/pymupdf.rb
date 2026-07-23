class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/8e/e9/6d6c5d6c0a3551bffd47681a6240caf941727f195b45593cf20ab36f018f/pymupdf-1.28.0.tar.gz"
  sha256 "e53f3567403a92da15caa9e7ae0164327fff48817e9f40175367fb9de524258d"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ad979d2bb83f0a55ab4356cbc52c70524047c75593d061e5ef8f9494e68c0166"
    sha256 cellar: :any, arm64_sequoia: "7a266bc5d4d9c2b8cd5b97d6cfb28289a105e0efcc9bfffaf4722b96cd127f87"
    sha256 cellar: :any, arm64_sonoma:  "47d35996fc8dfc0a8d2d7da126d5cbc3dbb1850bc9293dd1b41c969e73c8965e"
    sha256 cellar: :any, sonoma:        "9994bb6d47a08379083ae6e28ecb67e50dee67e95dd3b8bdb5f781fdf7c9aa12"
    sha256 cellar: :any, arm64_linux:   "5f6749dd841f8b0ae015cecc854ad734775392f4f805c3e1fec370f9d38c4e3a"
    sha256 cellar: :any, x86_64_linux:  "df2487a23ca46f87b75befe1cc8128dfc57f41aeac49cab1cfaeb115bc89ac08"
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
    ENV["PYMUPDF_INCLUDES"] = "#{formula_opt_include("mupdf")}:#{formula_opt_include("freetype")}/freetype2"
    ENV["PYMUPDF_SETUP_SWIG"] = formula_opt_bin("swig")/"swig"

    mupdf_libpath = formula_opt_lib("mupdf").to_s
    ENV["PYMUPDF_MUPDF_LIB"] = mupdf_libpath
    ENV.append "LDFLAGS", "-Wl,-rpath,#{mupdf_libpath}" if OS.mac?

    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
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
