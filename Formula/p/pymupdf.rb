class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/90/35/031556dfc0d332d8e9ed9b61ca105138606d3f8971b9eb02e20118629334/pymupdf-1.26.4.tar.gz"
  sha256 "be13a066d42bfaed343a488168656637c4d9843ddc63b768dc827c9dfc6b9989"
  license "AGPL-3.0-only"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "668b1f8cd28bc8a48bae99c70619523cc6299c2d67a2998515df4e38b0a3f693"
    sha256 cellar: :any,                 arm64_sequoia: "b5d7e3c3f6c6134911b6c30952b665c388297683132a2a915332c038379eadaa"
    sha256 cellar: :any,                 arm64_sonoma:  "7a02e6d966db886160ddda5208189bfc06465c5fbf2b1f227fdbf3b99447bdda"
    sha256 cellar: :any,                 sonoma:        "da6de7fb92744fd7aa8bf7fc2362411bd873d1b61930cf5742cfe99599250c49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3ddef2896d5b1e9f43cdf6cdc0161ce7fc3a9842d1b4da07d0201daf9767a53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f14810d395b346d49d184025fd56ed64e8622343c53100192918471c6fe3bf5d"
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
