class Pymupdf < Formula
  include Language::Python::Virtualenv

  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/a9/c5/25a5e7d63224bece0196207ab3e8f300abcd079051a79447be370d387e02/pymupdf-2.2.tar.gz"
  sha256 "593ad37f814496e359dea5c4d7532856842988bf35320cb3e25d03e9438ae236"
  license "AGPL-3.0-only"
  compatibility_version 1

  bottle do
    manifest_sha256 "caea6ef64f4eea37f797549c7eaccee530b239ea8b5589f8a56ce64ca0103a50"
    sha256 cellar: :any, arm64_golden_gate: "d43a41c84d5115f3e42e82e2c5cf5688337c6b568f1d8a271c49f5d426891fa4"
    sha256 cellar: :any, arm64_tahoe:       "f18175b29025abce11adbde80eb131f1c498e2a48ac65819e71ea703905bbbc9"
    sha256 cellar: :any, arm64_sequoia:     "68ada75d1cc94952c215ca0d1d428b195bbf77fc9660eb93aeb77d0c18297a5d"
    sha256 cellar: :any, arm64_linux:       "0022983543676cfa353edb02753435721d94ec22c7212889feac19732beb6cbe"
    sha256 cellar: :any, x86_64_linux:      "f97f5325efa942e48b2ab255e71d222f0b6f4ccc3e305fb6c706fe635b5cfc8b"
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
    url "https://files.pythonhosted.org/packages/c3/75/ffb1dc0ed12352139fb4ca0e3fde4325a23e3d0f3f40efe89717bc4f557b/packaging-26.4.tar.gz"
    sha256 "c4b671c41ddb9bf26e543c37723610d28fb6bf7affc4da17cf048d419d2c062a"
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

      import pymupdf

      in_pdf = sys.argv[1]
      out_png = sys.argv[2]

      # Convert first page to PNG
      pdf_doc = pymupdf.open(in_pdf)
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
