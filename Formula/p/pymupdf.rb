class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/40/fc/dd8776dc5c2f8cf0e51cf81a5f1de3840996bed7ca03ec768b0733024fb9/pymupdf-1.25.2.tar.gz"
  sha256 "9ea88ff1b3ccb359620f106a6fd5ba6877d959d21d78272052c3496ceede6eec"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c41de3a69324f2f385fd12fdb11a73739897ee420c09f54f3914c4fd4cc92f19"
    sha256 cellar: :any,                 arm64_sonoma:  "b36be5378c124f62b6b50dd2b173fb9f004701063e46b691f05beb9a9c975e00"
    sha256 cellar: :any,                 arm64_ventura: "fc5d1be3f3ec6fa33e7a7d3e0aa44637e46d11d3443198069f34fbbcc23b2787"
    sha256 cellar: :any,                 sonoma:        "c72646b5e85cd7813daa762d17ca6ae2040a55a8234496874fd2d2c3f006684c"
    sha256 cellar: :any,                 ventura:       "bcc60b7a1af0bca01655d94fca388b28f2719134ea5ba55358fac9e059949140"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ab6f32a92121c1b3348287c24115370625e31d682c76599b81d3223ee9571dd"
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
