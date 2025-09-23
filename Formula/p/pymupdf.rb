class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/90/35/031556dfc0d332d8e9ed9b61ca105138606d3f8971b9eb02e20118629334/pymupdf-1.26.4.tar.gz"
  sha256 "be13a066d42bfaed343a488168656637c4d9843ddc63b768dc827c9dfc6b9989"
  license "AGPL-3.0-only"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a89eb4e12b90312f0ec063713b8ecb0a278724bb71114502720d0ceac092b8d5"
    sha256 cellar: :any,                 arm64_sequoia: "a482363699522cb8dc3e6d378e6656c4b1b3d9149612c078b4aec95492573c57"
    sha256 cellar: :any,                 arm64_sonoma:  "77c90c1d577194201e619ed094b6386b20f9e9b992465f257678efb64373ce8e"
    sha256 cellar: :any,                 sonoma:        "d8760f4225c5f6a5ea1cac7654142fd15f373c29afaa14e21dea98021bf93e0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3198defc884355c76277b2d4882d0af4603c861bfd7f4fc7d4a2d1ca9e61afe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65d56ca9d961f7c04f0395cb5bf28abdefae504c5889ea41b45e9ff836e0c680"
  end

  depends_on "freetype" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "mupdf"
  depends_on "python@3.13"

  def python3
    "python3.13"
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
