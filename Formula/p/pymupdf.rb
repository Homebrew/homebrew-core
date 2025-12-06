class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/ec/d7/a6f0e03a117fa2ad79c4b898203bb212b17804f92558a6a339298faca7bb/pymupdf-1.26.6.tar.gz"
  sha256 "a2b4531cd4ab36d6f1f794bb6d3c33b49bda22f36d58bb1f3e81cbc10183bd2b"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d6e126cb114000b55fbef7b1845296d64ed28430e58fd351f87e66ceaccdadd8"
    sha256 cellar: :any,                 arm64_sequoia: "bcfaade18c83698d16954f8412d061ec5aed59a9f75400c1c2163f0f65744c42"
    sha256 cellar: :any,                 arm64_sonoma:  "fecf25db718c0661e8b404d78794b80fc562eb7653598a687078801df2096f15"
    sha256 cellar: :any,                 sonoma:        "01a490886deccbbb8f5949b2dba9e658e87ee47c55c8f07eecb584f20334b86c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "925fd3bfd2453b71adb17c4688d3887df394741cded1b34edb392c0bd97bbb0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78db30f20919c37e7508d30d106ae521ce4f91cfa991c1c3e181ab4d95311fee"
  end

  depends_on "freetype" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "mupdf"
  depends_on "python@3.14"

  def python3
    "python3.14"
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
