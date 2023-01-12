class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://github.com/pymupdf/PyMuPDF"
  url "https://files.pythonhosted.org/packages/30/44/9fce79689e5df7deebe2d17cb2b9b2a6b888439c241e71296e732aefa649/PyMuPDF-1.21.1.tar.gz"
  sha256 "f815741a435c62a0036bbcbf5fa6c533567bd69c5338d413714fc57b22db93e0"
  license "AGPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "dcf2e8cdf1a1284cafef1e6e95479acba8a38a8b7ccbed985fd72b0918699dce"
    sha256 cellar: :any,                 arm64_monterey: "576d765863e5bba94e6acac66f6e735692b8f181282a9311ce0ebc1038f0e0bb"
    sha256 cellar: :any,                 arm64_big_sur:  "db5275f8904bc7647ac25ca568aadc896abd997da21b7cfeca377fb59264f243"
    sha256 cellar: :any,                 ventura:        "61ed19a669b4deb0ad6763a2ed00d772c8635dc47270565e0d5671dab9ecb651"
    sha256 cellar: :any,                 monterey:       "0443c617bf6a5987f9f16ed95e2ef9a7cae2c053d94ffa86d8c184e59aa4209a"
    sha256 cellar: :any,                 big_sur:        "05491551aca406b23bde071e65b8c197a8e601154eecd9b6ae68839a487f0f06"
    sha256 cellar: :any,                 catalina:       "485853a0e4709f10cefeaca2b6fd7ae8ee908a37c32c8aa606dcff94aea51eb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59259dff9e2558567d8923ad7a2b1f444964177f1e4eaf9c7ba33671d4c6fb29"
  end

  depends_on "freetype" => :build
  depends_on "swig" => :build

  depends_on "mupdf"
  depends_on "python@3.11"

  on_linux do
    depends_on "gumbo-parser"
    depends_on "harfbuzz"
    depends_on "jbig2dec"
    depends_on "mujs"
    depends_on "openjpeg"
  end

  def python3
    "python3.11"
  end

  def install
    if OS.linux?
      ENV.append_path "CPATH", Formula["mupdf"].include/"mupdf"
      ENV.append_path "CPATH", Formula["freetype2"].include/"freetype2"
    end

    # Makes setup skip build stage for mupdf
    # https://github.com/pymupdf/PyMuPDF/blob/1.20.0/setup.py#L447
    ENV["PYMUPDF_SETUP_MUPDF_BUILD"] = ""

    system python3, *Language::Python.setup_install_args(prefix, python3), "build"
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
