class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://github.com/pymupdf/PyMuPDF"
  url "https://files.pythonhosted.org/packages/19/2d/73cb79152442ace5a6f55de17755e7c4c0dbed5ac6180baa1767d6a0e279/PyMuPDF-1.20.0.tar.gz"
  sha256 "443675ed28dc9be5c9521e17ff9a20299a78b8b94f4c457d7b7aa81899c00ee7"
  license "AGPL-3.0-only"

  depends_on "freetype" => :build
  depends_on "swig" => :build

  depends_on "mupdf"
  depends_on "python@3.9"

  on_linux do
    depends_on "mujs"
    depends_on "openjpeg"
    depends_on "gumbo-parser"
    depends_on "harfbuzz"
    depends_on "jbig2dec"
  end

  def install
    if OS.linux?
      pymupdf_dirs = {
        include_dirs: [
          Formula["mupdf"].include/"mupdf",
          Formula["freetype2"].include/"freetype2",
        ],
        library_dirs: [lib],
      }
      (buildpath/"pymupdf_dirs.env").write(pymupdf_dirs.to_json)

      # https://github.com/pymupdf/PyMuPDF/blob/1.20.0/setup.py#L630
      ENV["PYMUPDF_DIRS"] = File.expand_path("pymupdf_dirs.env")
    end

    # Makes setup skip build stage for mupdf
    # https://github.com/pymupdf/PyMuPDF/blob/1.20.0/setup.py#L447
    ENV["PYMUPDF_SETUP_MUPDF_BUILD"] = ""

    system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix), "build"
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import fitz"
  end
end
