class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/48/d6/09b28f027b510838559f7748807192149c419b30cb90e6d5f0cf916dc9dc/pymupdf-1.26.7.tar.gz"
  sha256 "71add8bdc8eb1aaa207c69a13400693f06ad9b927bea976f5d5ab9df0bb489c3"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ef42b609802efca6b500706222da4181b149071548ad35f912b07e191475d29c"
    sha256 cellar: :any,                 arm64_sequoia: "1aefe2ab221fb0c81bb65c911fe8705638a29e961cc460317c8042e9ef42551f"
    sha256 cellar: :any,                 arm64_sonoma:  "3624e11f3406d716b6b55f219606c600b74cfdd05a0a4dbf308438237a959725"
    sha256 cellar: :any,                 sonoma:        "14e453ef57ff19d4f672b1462a12b6cd2055fba527f6d3732de3671c13dd8659"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7fef809b76c383b9b1cc782496516ce23246f4f2527f4da629a85127b47bfcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e90333800e74be7879216166979b70ffe15219c09dfc7b45262e63109dcad0b"
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
