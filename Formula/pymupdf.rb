class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://github.com/pymupdf/PyMuPDF"
  url "https://files.pythonhosted.org/packages/19/2d/73cb79152442ace5a6f55de17755e7c4c0dbed5ac6180baa1767d6a0e279/PyMuPDF-1.20.0.tar.gz"
  sha256 "443675ed28dc9be5c9521e17ff9a20299a78b8b94f4c457d7b7aa81899c00ee7"
  license "AGPL-3.0-only"

  depends_on "freetype" => :build
  depends_on "swig" => :build

  depends_on "mupdf"
  depends_on "python@3.10"

  on_linux do
    depends_on "mujs"
    depends_on "openjpeg"
    depends_on "gumbo-parser"
    depends_on "harfbuzz"
    depends_on "jbig2dec"
  end

  def install
    if OS.linux?
      ENV.append "CPATH", Formula["mupdf"].include/"mupdf", ":"
      ENV.append "CPATH", Formula["freetype2"].include/"freetype2", ":"
    end

    # Makes setup skip build stage for mupdf
    # https://github.com/pymupdf/PyMuPDF/blob/1.20.0/setup.py#L447
    ENV["PYMUPDF_SETUP_MUPDF_BUILD"] = ""

    system "python3", *Language::Python.setup_install_args(prefix),
                      "--install-lib=#{prefix/Language::Python.site_packages("python3")}"
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

    system Formula["python@3.10"].opt_bin/"python3", testpath/"test.py", in_pdf, out_png
    assert_predicate out_png, :exist?
  end
end
