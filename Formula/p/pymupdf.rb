class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/06/47/b61c1c44b87cbdaeecdec3f43ce524ed6b3c72172bc6184eb82c94fbc43d/pymupdf-1.25.3.tar.gz"
  sha256 "b640187c64c5ac5d97505a92e836da299da79c2f689f3f94a67a37a493492193"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "58b0c5470064386f74c1831e771d25feb33d810ea0ad848ca55882af1b481204"
    sha256 cellar: :any,                 arm64_sonoma:  "72fef57ecdd517db13c24f4767e00fe9db4348631749b0d9338c7815536c214a"
    sha256 cellar: :any,                 arm64_ventura: "af270ef6df7aaab889b9485a7d5896db88bf2139c5960a3ce5f4cffc581a281c"
    sha256 cellar: :any,                 sonoma:        "f4b9749725ff5b58fc7cb8720bde5f3c5c899a1215eea9c6d425d97a6476251e"
    sha256 cellar: :any,                 ventura:       "7cedfda1c1ac8efddae80a666e51db55c0ff871957bfe12e87ea62f1f0b5bf7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6b7211c3085ef754ae44f54e1d4c34c7a4e57e40e32a3344e9f60c8555ef352"
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
