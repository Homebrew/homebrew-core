class Pymupdf < Formula
  include Language::Python::Virtualenv

  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/a9/c5/25a5e7d63224bece0196207ab3e8f300abcd079051a79447be370d387e02/pymupdf-2.2.tar.gz"
  sha256 "593ad37f814496e359dea5c4d7532856842988bf35320cb3e25d03e9438ae236"
  license "AGPL-3.0-only"
  revision 1
  compatibility_version 1

  bottle do
    manifest_sha256 "6292bb1d80e7625c359081db23c416702b58d468287390f47ffc46f96da59410"
    sha256 cellar: :any, arm64_golden_gate: "30525f7999fa45cb0b084ea108259503af893480abb2a23ca6619f6c5d991632"
    sha256 cellar: :any, arm64_tahoe:       "dc4bb5fc7f9abbc6ad62f3992e65bdcfb2c97c7a3a868c4b8a80cee0aecbff14"
    sha256 cellar: :any, arm64_sequoia:     "548bdd5bdbe7e7969644d2d55aa9b4269cc0a659bfaa7fa8b3350ad8ea223e04"
    sha256 cellar: :any, arm64_linux:       "7168655450732c3d4d2d4eb94a8d497421679901b50b5a0fd7bb31f614c4f46c"
    sha256 cellar: :any, x86_64_linux:      "84ae47ef79ea360d8246aa1529f245dab16bdfb31f89c01ebe85c9f4741b491f"
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
