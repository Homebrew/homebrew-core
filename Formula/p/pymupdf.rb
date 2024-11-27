class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/e0/6b/6bd735144a190d26dcc23f98b4aae0e09b259cc4c87bba266a39b7b91f56/PyMuPDF-1.24.14.tar.gz"
  sha256 "0eed9f998525eaf39706dbf2d0cf3162150f0f526e4a36b1748ffa50bde581ae"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5508c01e68aa780d289eac25180329d8cfacab94b7c704feb383c2b3cb34f696"
    sha256 cellar: :any,                 arm64_sonoma:  "2027a33c7d8581a8850f3726192dacf7045a06fa600b89b2712eea0e99026048"
    sha256 cellar: :any,                 arm64_ventura: "2490d3ff014c7e37c2b3ec4088cfa07a4a728cd008a4bd2633695482246701b0"
    sha256 cellar: :any,                 sonoma:        "91a80f3224f6cb1fb557dc67bd32b20c5ab63c2afe3eb91df16eed1070ecfc66"
    sha256 cellar: :any,                 ventura:       "b48815ca8574fa5e1a036d9bd4c47da98962b94eacd8731d3f77bbd04a30885a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "763356379c2d8a5f89da7c5e7cf96d92527748b3fa6d2782b4230d2a05f1de53"
  end

  depends_on "freetype" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "mupdf"
  depends_on "python@3.12"

  def python3
    "python3.12"
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
    assert_predicate out_png, :exist?
  end
end
