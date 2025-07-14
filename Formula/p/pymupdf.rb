class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/6d/d4/70a265e4bcd43e97480ae62da69396ef4507c8f9cfd179005ee731c92a04/pymupdf-1.26.3.tar.gz"
  sha256 "b7d2c3ffa9870e1e4416d18862f5ccd356af5fe337b4511093bbbce2ca73b7e5"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a5ecdcb5988746bce6a5d6ca8dfc04bae4dc58550988aab7aa3566ec9943d5a1"
    sha256 cellar: :any,                 arm64_sonoma:  "591c6ee345fe0698d7257a16cf7be042e8c1b8e1ade3b1a013a602d1ac3758bc"
    sha256 cellar: :any,                 arm64_ventura: "9e3e72739d5b7095fbf47db261945652dfc0ab6433d85112f98bb3ac98ba2305"
    sha256 cellar: :any,                 sonoma:        "56538455efcc871d4cabd0eebf4df3eaca5dc344764e7d253fb20c4f91adecc3"
    sha256 cellar: :any,                 ventura:       "b2db104a04f441630ac907ab3031a33957b0416bfa41ce587637b86e9a4568cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d1a193cfd1192bb175e06dffb1061e03d62fd80214ca00ad5b36f103ca50605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4daea4b100ff01c626355d937d3607bcc91757f656c82fdf993f4f618f13d7c8"
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
