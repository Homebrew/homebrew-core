class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/6d/d4/70a265e4bcd43e97480ae62da69396ef4507c8f9cfd179005ee731c92a04/pymupdf-1.26.3.tar.gz"
  sha256 "b7d2c3ffa9870e1e4416d18862f5ccd356af5fe337b4511093bbbce2ca73b7e5"
  license "AGPL-3.0-only"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "623a18749dd1b7c60321506fb6c83b3dbedee729163f11008d26253874b69dac"
    sha256 cellar: :any,                 arm64_sonoma:  "4362bc744aa31564dfbffc03e3655bb954af48e052cf9d91f906a22d1cde0f6d"
    sha256 cellar: :any,                 arm64_ventura: "74b837fe089d506b639c5d6035eff7ebb7666870f93c17b32041f12c597051d2"
    sha256 cellar: :any,                 sonoma:        "74764e28e71a43671bd4c2079533e87a80b0677b1fdbe567121646b3837cd87a"
    sha256 cellar: :any,                 ventura:       "dc693617b483a2e304987b41e03559d877ef4cc05c869e046d4b20098e0c788b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c0e2c561a120cae84433a8c5cf19b3488e633797a429963ee8e2c91fbcc923f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87c8677e257f7785dd2f3e3c100489a0a61902147a3c005fd8954afc52300917"
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
