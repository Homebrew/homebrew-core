class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  # FIXME: switch to PyPI source distribution when it becomes available again
  # https://github.com/pymupdf/PyMuPDF/issues/4945
  url "https://github.com/pymupdf/PyMuPDF/archive/refs/tags/1.27.2.tar.gz"
  sha256 "51f3800190f23d40fedf3c4808b0fbd13f77ecd0fad84299182d8a319b8f9a2b"
  license "AGPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "5e775775b06e7dcaa9f6a0045edff684d412eddf4bf9a414b355195742aed0ee"
    sha256 cellar: :any,                 arm64_sequoia: "2f5ec72ff3bd5a5cdae7e7d908fc8f3bf32de3bdd8239529130b76aaf88676dd"
    sha256 cellar: :any,                 arm64_sonoma:  "83b32f97f3bccca3c5ef9b2989a32e3fd42f3b87c188aeef4420f5112567919f"
    sha256 cellar: :any,                 sonoma:        "57f1d9cbcf729e32c8a2b7ce674d9f870550d0c9c5bba5dbb279ad7805de01e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "136e9ca0f4360b3d652ba7e4dbd997ab6a1ea631edc897d1ed84db0caf028372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c10c04339cba2f5914b29299be560f3a6a584ec10b6826345eb2ed7aec1b7fe8"
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

    mupdf_libpath = Formula["mupdf"].opt_lib.to_s
    ENV["PYMUPDF_MUPDF_LIB"] = mupdf_libpath
    ENV.append "LDFLAGS", "-Wl,-rpath,#{mupdf_libpath}" if OS.mac?

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
