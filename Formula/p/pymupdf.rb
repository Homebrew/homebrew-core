class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/d4/a3/3edbb6be649e311107b320141cae0353d4cc9c6593eba7691f16c53c9c71/PyMuPDF-1.24.11.tar.gz"
  sha256 "6e45e57f14ac902029d4aacf07684958d0e58c769f47d9045b2048d0a3d20155"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "34f23b4dc51ae87c876bffad5fa3df6be540bf6e13cb5d732d380f3d1ac0fbd5"
    sha256 cellar: :any,                 arm64_sonoma:  "5a248e1d55dc204b50f6dd43cc1cf717e232ad2d8dacff85c2b4adc3a31393f3"
    sha256 cellar: :any,                 arm64_ventura: "6e510bb18caafa3ae52dc08df5a57ca7737d3b0a9e9876fe19defb476fda3de2"
    sha256 cellar: :any,                 sonoma:        "2adcdfa8add456e1193f59b1fb38b266dd0408c12f11a40098c55f7072b475ae"
    sha256 cellar: :any,                 ventura:       "bde34a88583600ac9805414a1336e24ffd4becb20e45c72b4846183fede7e5ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdcbfc36d4b86727d774efd0403ef4d5d898d44cb235a0c5cfa915c8b79816ce"
  end

  depends_on "freetype" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "mupdf"
  depends_on "python@3.12"

  def python3
    "python3.12"
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
    (testpath/"test.py").write <<~EOS
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
    EOS

    in_pdf = test_fixtures("test.pdf")
    out_png = testpath/"test.png"

    system python3, testpath/"test.py", in_pdf, out_png
    assert_predicate out_png, :exist?
  end
end
