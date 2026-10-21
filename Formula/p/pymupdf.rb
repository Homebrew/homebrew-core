class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/a3/fb/b6761fa2d5266f2cdb24c3b91f4023070ab7848381417678e7a289a1d52a/pymupdf-1.28.2.tar.gz"
  sha256 "5e0be7908a715aa20333caddd73f1d6f01e4cd0c26e869fa2dd0b7f344da2249"
  license "AGPL-3.0-only"
  revision 4

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e8a6bb005a77df7854f36861ec0f4fb1894a6e4e0e9b10cc7d234c2991a67564"
    sha256 cellar: :any, arm64_tahoe:       "717e8a060a9ecc62e422257259debd066e4f513b271e0b33e5f621e7eef0ceba"
    sha256 cellar: :any, arm64_sequoia:     "863c6b90d3d3bdc5849defa454e15955f4bc45cdcd4911b58514697e26b59165"
    sha256 cellar: :any, arm64_linux:       "a51daa6deccd2797ec86157369952e252789824a549dd891ced76196f4746654"
    sha256 cellar: :any, x86_64_linux:      "f61306fa70cbe91fb092e5a1001c8b67e00c26fba589deee43a52292287fce35"
  end

  depends_on "freetype" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "mupdf"
  depends_on "python@3.15"

  # Stop using the Python 2 C API macros that swig 4.5 no longer defines
  patch do
    url "https://github.com/pymupdf/PyMuPDF/commit/7f419a5bed7b257416f6837580dc4325e240e625.patch?full_index=1"
    sha256 "5b809a94ea89bedd215f4424c501c2e0b7800b460a8d1641ac910d88f57ae4bf"
    type :unofficial
    resolves "https://github.com/pymupdf/PyMuPDF/pull/5072"
  end

  def install
    # Makes setup skip build stage for mupdf
    # https://github.com/pymupdf/PyMuPDF/blob/1.20.0/setup.py#L447
    ENV["PYMUPDF_SETUP_MUPDF_BUILD"] = ""
    ENV["PYMUPDF_INCLUDES"] = "#{formula_opt_include("mupdf")}:#{formula_opt_include("freetype")}/freetype2"
    ENV["PYMUPDF_SETUP_SWIG"] = formula_opt_bin("swig")/"swig"

    mupdf_libpath = formula_opt_lib("mupdf").to_s
    ENV["PYMUPDF_MUPDF_LIB"] = mupdf_libpath
    ENV.append "LDFLAGS", "-Wl,-rpath,#{mupdf_libpath}" if OS.mac?

    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
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
