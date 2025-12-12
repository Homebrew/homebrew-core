class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/48/d6/09b28f027b510838559f7748807192149c419b30cb90e6d5f0cf916dc9dc/pymupdf-1.26.7.tar.gz"
  sha256 "71add8bdc8eb1aaa207c69a13400693f06ad9b927bea976f5d5ab9df0bb489c3"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0111cd0136789c1d0dc81f8c0c955213299fd080dfccf60872215117073909b8"
    sha256 cellar: :any,                 arm64_sequoia: "5fe46d87df57b9ae1aa0816514de07a904c32820e16f1164128508fc75a8d689"
    sha256 cellar: :any,                 arm64_sonoma:  "b2be496d683ee29c0f56c3be754e05080424ff0bac33a508ab8a7eb25f1c11ae"
    sha256 cellar: :any,                 sonoma:        "699c7a839e15f6af61f3b05cb5a61c54e2b6f3e154ff99e07c522f6b2626cbbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76b5f7510652546e6616ce3fd2c4bdda19b33e20a74157bc40c51df8523a3e4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa8850f29fab7568822eee03aff9983a56c025131365d552633dad75a13a480e"
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
    ENV["PYMUPDF_MUPDF_LIB"] = Formula["mupdf"].opt_lib.to_s

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
