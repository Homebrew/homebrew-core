class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://github.com/pymupdf/PyMuPDF"
  url "https://files.pythonhosted.org/packages/4a/09/6afe87a8ea7acb6e4709223a704270ffe9929497add4d06b12305e229ba8/PyMuPDF-1.20.2.tar.gz"
  sha256 "02eedf01f57c6bafb5e8667cea0088a2d2522643c47100f1908bec3a68a84888"
  license "AGPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "dcf2e8cdf1a1284cafef1e6e95479acba8a38a8b7ccbed985fd72b0918699dce"
    sha256 cellar: :any,                 arm64_monterey: "576d765863e5bba94e6acac66f6e735692b8f181282a9311ce0ebc1038f0e0bb"
    sha256 cellar: :any,                 arm64_big_sur:  "db5275f8904bc7647ac25ca568aadc896abd997da21b7cfeca377fb59264f243"
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
