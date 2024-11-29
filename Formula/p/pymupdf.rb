class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/e0/6b/6bd735144a190d26dcc23f98b4aae0e09b259cc4c87bba266a39b7b91f56/PyMuPDF-1.24.14.tar.gz"
  sha256 "0eed9f998525eaf39706dbf2d0cf3162150f0f526e4a36b1748ffa50bde581ae"
  license "AGPL-3.0-only"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a57c53248b96fe29522e7bd245c244cdae6d81a057ba35b2a93845096165843c"
    sha256 cellar: :any,                 arm64_sonoma:  "b139543e1cf8136199663f8c135598b1c77905dba75639b07a133d0bb3092cd1"
    sha256 cellar: :any,                 arm64_ventura: "f1897ea07f4ac516971284dcd3ee72a0d0f416a1346a2288114420e503528637"
    sha256 cellar: :any,                 sonoma:        "15c1decd848a69ff2aba30123d9f4fc390ce46c90bd2baa7d1821e0076a5651f"
    sha256 cellar: :any,                 ventura:       "b2eb78ea0ecc16d884734d929e634a79c2561468a65ad4f8349e57918dca5aa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94b0094ce299c55da3ff40d9861a9b880495d203edaf90c29289a60b5da076ae"
  end

  depends_on "freetype" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "mupdf"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  # fix build with mupdf 1.25.0, upstream pr ref, https://github.com/pymupdf/PyMuPDF/pull/4094
  patch do
    url "https://github.com/pymupdf/PyMuPDF/commit/8609db72eb59d95ffa37c05991a0b83220865677.patch?full_index=1"
    sha256 "3582c6ad6dcd5bc476913128fb3e922b6be9b18d6ed51b1fad1e88acd3b0aaa4"
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
