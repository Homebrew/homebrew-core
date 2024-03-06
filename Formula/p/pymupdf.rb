class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/c5/47/ebd9cdc09d82462533f69f983c7f57ebbf01e68adb111a3c49acacde2540/PyMuPDF-1.23.26.tar.gz"
  sha256 "a904261b317b761b0aa2bd2c1f6cd25d25aa4258be67a90c02a878efc5dca649"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c43eaabbda986e9e2e387c177e3fcfb3e8a688fbd68d599466badfbf95c559a6"
    sha256 cellar: :any,                 arm64_ventura:  "a9a8779a131db07af5bc20ef1b2bb7bdcc92523d7ccff472c33380ba58b83d8e"
    sha256 cellar: :any,                 arm64_monterey: "212d03bc3e39dfac09a9136b107ef37e35bbca15fb168eea65ad012427503e98"
    sha256 cellar: :any,                 sonoma:         "4460d8dbcf1e0903f99440e4af975cf18f11409aaa658d3314e8d1fe7d3efc9d"
    sha256 cellar: :any,                 ventura:        "920ab94f164fc33a333a839ac75ed377fa6eca5b006627354a4997e9325a1753"
    sha256 cellar: :any,                 monterey:       "5f9155f054b8775b5817bf7b15f79e89f25600c68cb3fe9e74d1ad7870e11460"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cdc726ae89a1d66a80526abfeb7bd380fee4e5b2aa2027bd352f31a78418460"
  end

  depends_on "freetype" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build

  depends_on "mupdf"
  depends_on "python@3.12"

  on_linux do
    depends_on "gumbo-parser"
    depends_on "harfbuzz"
    depends_on "jbig2dec"
    depends_on "mujs"
    depends_on "openjpeg"
  end

  def python3
    "python3.12"
  end

  def install
    # Makes setup skip build stage for mupdf
    # https://github.com/pymupdf/PyMuPDF/blob/1.20.0/setup.py#L447
    ENV["PYMUPDF_SETUP_MUPDF_BUILD"] = ""
    # Builds only classic implementation
    # https://github.com/pymupdf/PyMuPDF/issues/2628
    ENV["PYMUPDF_SETUP_IMPLEMENTATIONS"] = "a"
    ENV["PYMUPDF_INCLUDES"] = "#{Formula["mupdf"].opt_include} -I#{Formula["freetype"].opt_include}/freetype2"
    ENV["PYMUPDF_MUPDF_LIB"] = Formula["mupdf"].opt_lib.to_s

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath/"test.py").write <<~EOS
      import sys
      from pathlib import Path

      # per 1.23.9 release, `fitz` module got renamed to `fitz_old`
      import fitz_old as fitz

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
