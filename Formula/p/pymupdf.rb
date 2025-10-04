class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/90/35/031556dfc0d332d8e9ed9b61ca105138606d3f8971b9eb02e20118629334/pymupdf-1.26.4.tar.gz"
  sha256 "be13a066d42bfaed343a488168656637c4d9843ddc63b768dc827c9dfc6b9989"
  license "AGPL-3.0-only"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0aaeba32defa1c5bbee06086f9846a1f23b6d445d6cff4c0ce349f87b1b74357"
    sha256 cellar: :any,                 arm64_sequoia: "9e81ff8c2292726ae5a2eed08ce8522641237d07dec9fcfd89bda3a2ed0e2dcd"
    sha256 cellar: :any,                 arm64_sonoma:  "be8562fd0e01802d5d6edb2b800dc60258ff21154a81d9391bf6f55cdf72d6aa"
    sha256 cellar: :any,                 sonoma:        "aefaf568ee317bd8dd73e83a19c1bfc94285ea56201b2c905202d99c27adc018"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "421ef62bdcd3f77f030fb350770e3aa71d4143f9e14c1b94c01ff2c6d91b1444"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "016e9e7eb2ffd8bb9e51f6ffe79ebac7036e09a2e99ebaa093a377e57a4a42f4"
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
