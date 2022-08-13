class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://github.com/pymupdf/PyMuPDF"
  url "https://files.pythonhosted.org/packages/4a/09/6afe87a8ea7acb6e4709223a704270ffe9929497add4d06b12305e229ba8/PyMuPDF-1.20.2.tar.gz"
  sha256 "02eedf01f57c6bafb5e8667cea0088a2d2522643c47100f1908bec3a68a84888"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9f0283ec89b9a9e8980c9096ac0721d1fc99bede52ac94cc4857e25c4be3fc1e"
    sha256 cellar: :any,                 arm64_big_sur:  "690c275465aa2a185ef108981a554728b2b9fd80714b198c7655c9beba926aab"
    sha256 cellar: :any,                 monterey:       "726bdce11c396dd0cc746373af0c88512b16afa40017d82181b3002aac3c5381"
    sha256 cellar: :any,                 big_sur:        "8de5db3b5be1f1b453d6e083b95cd965774c7c31407cca6c1f6d8e5fc21e63bc"
    sha256 cellar: :any,                 catalina:       "4bea5e516efea685c1b4b026d0157ef254838a7e4583d1affc546c1b352b15c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07c10633ddf7ce68d692b249278c19d11774609374463ed7b8056cc45630d5fd"
  end

  depends_on "freetype" => :build
  depends_on "swig" => :build

  depends_on "mupdf"
  depends_on "python@3.10"

  on_linux do
    depends_on "gumbo-parser"
    depends_on "harfbuzz"
    depends_on "jbig2dec"
    depends_on "mujs"
    depends_on "openjpeg"
  end

  def install
    if OS.linux?
      ENV.append_path "CPATH", Formula["mupdf"].include/"mupdf"
      ENV.append_path "CPATH", Formula["freetype2"].include/"freetype2"
    end

    # Makes setup skip build stage for mupdf
    # https://github.com/pymupdf/PyMuPDF/blob/1.20.0/setup.py#L447
    ENV["PYMUPDF_SETUP_MUPDF_BUILD"] = ""

    system "python3", *Language::Python.setup_install_args(prefix), "build"
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
