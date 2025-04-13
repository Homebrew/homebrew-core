class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/f9/af/3d5d363241b9a74470273cf1534436f13a0a61fc5ef6efd19e5afe9de812/pymupdf-1.25.5.tar.gz"
  sha256 "5f96311cacd13254c905f6654a004a0a2025b71cabc04fda667f5472f72c15a0"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3b76825052eaaac7c71e5be853196d5ba19fd98be5885a2e01f69f07dd65ab46"
    sha256 cellar: :any,                 arm64_sonoma:  "e7313345450e93d2ea93a914805554add8d8500ca4b9e42d40e98910318c2ee2"
    sha256 cellar: :any,                 arm64_ventura: "8db0af7fe4004bdaea575470776ae1c5cb7af43fb80ba0dccfe6d09877371c13"
    sha256 cellar: :any,                 sonoma:        "24dc1baee24e9072f28bef46e7b1ea7b36efdcf42da098af5d1850696b978fd5"
    sha256 cellar: :any,                 ventura:       "6aa7f4c2ae45800f2db6574e13f5d3afec61590095c760525b8190647ce1534f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a74d6dfcb1bcdf3617c2e616fa6be385204fdf3b5ded3f99429c29ee40297fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5ca11cffff40105ea756362889762c52fe9dc018a8b53d4135e49fb57f34c09"
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
