class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/22/32/708bedc9dde7b328d45abbc076091769d44f2f24ad151ad92d56a6ec142b/pymupdf-1.27.2.3.tar.gz"
  sha256 "7a92faa25129e8bbec5e50eeb9214f187665428c31b05c4ef6e36c58c0b1c6d2"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "05889f7a1307899408eddf9b8822d91428cb1e4df32cc8b854c83b35234ab270"
    sha256 cellar: :any,                 arm64_sequoia: "c4152bb0d18556ddbbd66b8715643be564b37fb52d065b6759f0e37479ff18da"
    sha256 cellar: :any,                 arm64_sonoma:  "55689a970e4245e551cc3dfe16296124b9d86ef8312df8bb5e3d0e39e6715f1d"
    sha256 cellar: :any,                 sonoma:        "78624b43fbaa4f66aab09d86940e4a110b02b8842f3c2409c39b5359dfcb75fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b3eae3d4420c1a84de8e30e4fe668491257e5fd7518eed5b0a0595acc8e7ee1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b23f30aeb8215a6d6c45507614d6336973cbd06aa45c7acb86cd1c8662e772f"
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
    ENV["PYMUPDF_SETUP_SWIG"] = Formula["swig"].opt_bin/"swig"

    mupdf_libpath = Formula["mupdf"].opt_lib.to_s
    ENV["PYMUPDF_MUPDF_LIB"] = mupdf_libpath
    ENV.append "LDFLAGS", "-Wl,-rpath,#{mupdf_libpath}" if OS.mac?

    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
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
