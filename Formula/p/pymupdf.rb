class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/40/fc/dd8776dc5c2f8cf0e51cf81a5f1de3840996bed7ca03ec768b0733024fb9/pymupdf-1.25.2.tar.gz"
  sha256 "9ea88ff1b3ccb359620f106a6fd5ba6877d959d21d78272052c3496ceede6eec"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "22a40bf92634f691e7164b256f157f97c4de90fed0e48dbda6ac9c7018f7b51d"
    sha256 cellar: :any,                 arm64_sonoma:  "3affb23cd9280beac4ca7bb06733482a2b78ab13dd3234f2445b688f6197f1ae"
    sha256 cellar: :any,                 arm64_ventura: "f0eaccb0e0ecc6503627300f3b4ea76a07417a14fdf881941b739b2666a51850"
    sha256 cellar: :any,                 sonoma:        "69c3db66d5b44707cc3d728f207946f8979deff345fccb1ab15f3af1dff3e519"
    sha256 cellar: :any,                 ventura:       "c90cb04249447692d047fec2f644b639e36df71e389a44864237618377b19666"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a4208c3e9b3f60417e7da0a66990bdc71bac08df43f420121c6bb3b06a8dc54"
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
