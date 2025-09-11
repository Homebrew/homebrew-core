class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/90/35/031556dfc0d332d8e9ed9b61ca105138606d3f8971b9eb02e20118629334/pymupdf-1.26.4.tar.gz"
  sha256 "be13a066d42bfaed343a488168656637c4d9843ddc63b768dc827c9dfc6b9989"
  license "AGPL-3.0-only"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "30447aa3436d68495ab1fba178066a967feb59aaa184598ec29fd05343d47a07"
    sha256 cellar: :any,                 arm64_sonoma:  "f13d5a2c511203775d5bb6e275fb63be44d8d7075978f47096a07260f56949de"
    sha256 cellar: :any,                 arm64_ventura: "6b331374a9f9d7f2954dc887b0d4c08b88eaa3ae7ec69639f77a9acb27ab0015"
    sha256 cellar: :any,                 sonoma:        "1816927fb491cd01b769fd28d09a0f07f478ca2efd6d9674c03f33c4ce828eeb"
    sha256 cellar: :any,                 ventura:       "1ccc8c838f22474311c4e07eacbacf1777c8733cc201fe2ecd0c08dbecf2e63f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b57e6efc9f6066d4165608a3524ee33db06dc3df694620679fe414bb78cae02c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a6c84254c456ab5b4bc7c7719060c513630ca4926765e78341cf53d8e52eebd"
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
