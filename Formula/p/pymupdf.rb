class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/99/13/d9f3b67b98111e79307e2a3cf6d5f73daaca002144cc6d236c4a0adbc386/pymupdf-1.26.0.tar.gz"
  sha256 "ffe023f820379c84a0ddae38b0d07ea4016e1de84929491c34415520c629bcce"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b0ae84a83ca13a45fdf567f79821532f642faef2bf0b031de18c24e59d2841ec"
    sha256 cellar: :any,                 arm64_sonoma:  "a83fd1c58c06ba629d8a81faf50abf29f035ce3e51ce1ff34ed86704617d480b"
    sha256 cellar: :any,                 arm64_ventura: "dba891887ca0d5c27fc67cb9eee2e8d1ecbdc9e727cc8a68863cd6dd2230f3c9"
    sha256 cellar: :any,                 sonoma:        "4e780f10dcf829b0a29e5e1cd9df6c44411db0861c71cc7f345c1df00b57e413"
    sha256 cellar: :any,                 ventura:       "e84ec87b72b331c4b5c2ac0d9cf9ff572e5f6048e4791bc6d9c9b6dceefb3329"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3664b2d2b2a68384e966008f2cd10da6decaa575b4ce84fb753c3b3f54654c26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db3ba5cdff301f01a10f0c7422c8b9033c43e88a46ec09e01f500205e36dcad5"
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
