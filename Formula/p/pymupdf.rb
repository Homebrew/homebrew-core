class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/e0/6b/6bd735144a190d26dcc23f98b4aae0e09b259cc4c87bba266a39b7b91f56/PyMuPDF-1.24.14.tar.gz"
  sha256 "0eed9f998525eaf39706dbf2d0cf3162150f0f526e4a36b1748ffa50bde581ae"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e3636428dd744d344917b8fbb63b0c82d80688304cfd99247510f5f84a25e1e1"
    sha256 cellar: :any,                 arm64_sonoma:  "e6f42d332d2925ac2270a981f391a5a4ddbd18574ee9935cfd1a4e05bf4d265e"
    sha256 cellar: :any,                 arm64_ventura: "5d29e78e6643ec37d15e3f463cba6c6814bca30964c5875281495c6d1271ca8c"
    sha256 cellar: :any,                 sonoma:        "e3b1fea8acf2db4f1b62d077d8ba1bc7ba33e6e94ef2422284547cd6884682c8"
    sha256 cellar: :any,                 ventura:       "d8176094ed6332c97de6aa696404c0336229bda46ed058059e1d22881d746640"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c48b2b9d0a491a85b8a2b64e81e008ec5b9f024db1bc2808888169cef44f1987"
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
