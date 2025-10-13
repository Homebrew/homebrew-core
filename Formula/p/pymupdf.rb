class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/8d/9a/e0a4e92a85fc17be7c54afdbb113f0ade2a8bca49856d510e28bd249e462/pymupdf-1.26.5.tar.gz"
  sha256 "8ef335e07f648492df240f2247854d0e7c0467afb9c4dc2376ec30978ec158c3"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "37d88d2c1ab3c903d6481aad93aff6eebeaf2b0aba98a4c060bd354c7540f5eb"
    sha256 cellar: :any,                 arm64_sequoia: "4c9028ff28a06122c048e4b8af963ccee781a7317a5ec6d5b4fd3051b18f041d"
    sha256 cellar: :any,                 arm64_sonoma:  "7d18abd0340fc3b7b3378d24d202c269a263f242c8185bb7b916032733912d86"
    sha256 cellar: :any,                 sonoma:        "bded671083f9f455d64336df1aad479ff671f9e11a0fb12c591cdf502db48ba6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fdde563d760ce980393a3a9c85fca432ccdada3f80ca863b3e24a1c75147713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af404d42a2eb55735a36fe2b2f47f1144f0e9760416ae64313cacffd10658600"
  end

  depends_on "freetype" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "mupdf"
  depends_on "python@3.14"

  def python3
    "python3.14"
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
