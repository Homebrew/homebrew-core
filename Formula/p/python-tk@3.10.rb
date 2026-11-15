class PythonTkAT310 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.10.22/Python-3.10.22.tgz"
  sha256 "9448b34d16f8e3db0964ac3ed9fb283197747543c2c021f283ffd2c8b7287357"
  license "Python-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "601d74823b6a4f89de6e47a05163444b612d491ebe40504386cad247ab60ddac"
    sha256 cellar: :any, arm64_tahoe:       "3c47717207f20bde1abf286ad572feeebc0c845a5e45e597c246c1acd4060939"
    sha256 cellar: :any, arm64_sequoia:     "124743bbd73ff795ed4be5bbd0f189ae832df49d3a51fca4185c03b0ad4eb163"
    sha256 cellar: :any, arm64_linux:       "04cce512105a2c1e9b55989100cd56216f7f8143a14896087d2ce0363a67930d"
    sha256 cellar: :any, x86_64_linux:      "02350ecc532c8df68740b5cdd07cda75ea04d49ea13136110a855b56c0ac3d91"
  end

  keg_only :versioned_formula

  # https://devguide.python.org/versions/#unsupported-versions
  deprecate! date: "2026-10-01", because: :deprecated_upstream
  disable! date: "2027-10-01", because: :deprecated_upstream

  depends_on "python@3.10"
  depends_on "tcl-tk@8"

  deny_network_access!

  def install
    cd "Modules" do
      tcltk = Formula["tcl-tk@8"]
      tcltk_version = tcltk.any_installed_version.major_minor
      Pathname("setup.py").write <<~PYTHON
        from setuptools import setup, Extension

        setup(name="tkinter",
              description="#{desc}",
              version="#{version}",
              ext_modules = [
                Extension("_tkinter", ["_tkinter.c", "tkappinit.c"],
                          define_macros=[("WITH_APPINIT", 1)],
                          include_dirs=["#{tcltk.opt_include/"tcl-tk"}"],
                          libraries=["tcl#{tcltk_version}", "tk#{tcltk_version}"],
                          library_dirs=["#{tcltk.opt_lib}"])
              ]
        )
      PYTHON
      system python3, "-m", "pip", "install", *std_pip_args(prefix: false), "--target=#{libexec}", "."
      rm_r libexec.glob("*.dist-info")
    end
  end

  test do
    system python3, "-c", "import tkinter"
  end
end
