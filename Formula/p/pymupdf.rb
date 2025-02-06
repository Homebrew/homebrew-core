class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/40/fc/dd8776dc5c2f8cf0e51cf81a5f1de3840996bed7ca03ec768b0733024fb9/pymupdf-1.25.2.tar.gz"
  sha256 "9ea88ff1b3ccb359620f106a6fd5ba6877d959d21d78272052c3496ceede6eec"
  license "AGPL-3.0-only"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e99e2244b6bebc3bbf88d463568e1dd996088e239127ab172f737856cb349c31"
    sha256 cellar: :any,                 arm64_sonoma:  "a77ba0db923fbd0ef2955b0431e7999f109a8ad0c690d9e16a9c8001aa59f78c"
    sha256 cellar: :any,                 arm64_ventura: "6a8592a1ac76d165435786f71fe22435cbbe0840b447d7f6b0ddac6c12d11ae4"
    sha256 cellar: :any,                 sonoma:        "002148d8f4bd9ba10a1400e56b34d866dc45a72b02347730196922f819dd407c"
    sha256 cellar: :any,                 ventura:       "10d138260cbf2a43c96314e8a2db6e0dd474a0b3d79723e6160e0b15fb3f6ad3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3094f6b2e3a194c232027620c97ffa2203133dd389502aa9ef4bdde26f2538a"
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
    assert_predicate out_png, :exist?
  end
end
