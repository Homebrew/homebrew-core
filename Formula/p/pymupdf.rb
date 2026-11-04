class Pymupdf < Formula
  include Language::Python::Virtualenv

  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/13/d9/5ae3cce31a4a62de4f6979331b4d8d5b86a8f2520f06754cf5e69065c887/pymupdf-2.1.tar.gz"
  sha256 "9ac95f98016e83eafb8f1d786396f9c60e400d559590596e5b2df9eb6384948b"
  license "AGPL-3.0-only"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f74746d26f0297957c5d8ed057c7ddc295f0c3b94bc0a26f00a7ab1ab8e88f61"
    sha256 cellar: :any, arm64_tahoe:       "cfbecbe86e0abb38331084f90a5bebf7120ecbd26a0f574e4e94fe91bf1eb918"
    sha256 cellar: :any, arm64_sequoia:     "208b516d7217ebc94cbd52f54464b9472b6fca72babceeaa40a91e6f6837bdd9"
    sha256 cellar: :any, arm64_linux:       "21468bb70abf05867dbaacb918398a85c87618dc1392a276c1a901c19c091fda"
    sha256 cellar: :any, x86_64_linux:      "bbf9a0710ae7f1ee5bba7324dd231f8178ea357f69572fd37ccd5d3dfc93218b"
  end

  depends_on "freetype" => :build
  depends_on "swig" => :build
  depends_on "mupdf"
  depends_on "python@3.15"

  resource "pipcl" do
    url "https://files.pythonhosted.org/packages/1c/9d/d797318cf82fff625670bbbf88a722d87299c9d8f3fc8372603713ac0af4/pipcl-13.tar.gz"
    sha256 "286aba9785463c83659a565210a82a77896195d3303bff0542e825479b56daf2"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  # Fix system MuPDF library paths, upstream PR ref, https://github.com/pymupdf/PyMuPDF/pull/5197
  patch do
    url "https://github.com/pymupdf/PyMuPDF/commit/4b4139e40fa68cd69e20e23c0f6360f818594f83.patch?full_index=1"
    sha256 "5eb995985cdf7a0ca7b09d4652d8b284d4988d2cdc4014ed8dd904fa593f6482"
    type :unofficial
    resolves "https://github.com/pymupdf/PyMuPDF/pull/5197"
  end

  def install
    venv = virtualenv_create(buildpath/"build-deps", python3)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", venv.site_packages

    # Makes setup skip build stage for mupdf
    # https://github.com/pymupdf/PyMuPDF/blob/1.20.0/setup.py#L447
    ENV["PYMUPDF_SETUP_MUPDF_BUILD"] = ""
    ENV["PYMUPDF_INCLUDES"] = "#{formula_opt_include("mupdf")}:#{formula_opt_include("freetype")}/freetype2"
    ENV["PYMUPDF_SETUP_SWIG"] = formula_opt_bin("swig")/"swig"

    mupdf_libpath = formula_opt_lib("mupdf").to_s
    ENV["PYMUPDF_MUPDF_LIB"] = mupdf_libpath
    ENV.append "LDFLAGS", "-Wl,-rpath,#{mupdf_libpath}" if OS.mac?

    # The core bindings are built as pymupdf-lite in 2.x, without the optional layout/LLM components.
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
