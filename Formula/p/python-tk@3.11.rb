class PythonTkAT311 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.11/Python-3.11.11.tgz"
  sha256 "883bddee3c92fcb91cf9c09c5343196953cbb9ced826213545849693970868ed"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1f9a321e1e78d1d97c5f0235b1b168a124eeb14d2af9a7bbe5779caa4cf65b2a"
    sha256 cellar: :any,                 arm64_sonoma:  "50a82472575c5e5274ce30a645e1001525a6b687277fc3135ae04fb52218b605"
    sha256 cellar: :any,                 arm64_ventura: "7e9a75628c3b4774de3ce15011d2038825cca1cbfb63054c164ecc9df77249e7"
    sha256 cellar: :any,                 sonoma:        "b4a2ddb66b65e9d51480f723b20c0f283e13916e07eb71a8d33e373c312d05cf"
    sha256 cellar: :any,                 ventura:       "0878dd7791494b7fd30b35e67e8dda93134c18923c55e2e5d0dba9f0a55645ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6659be61ea14b718d3bae6f0a4992e51b131867a469bc7c865f4e5490185411d"
  end

  depends_on "python@3.11"
  depends_on "tcl-tk@8"

  def python3
    "python3.11"
  end

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

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system python3, "-c", "import tkinter; root = tkinter.Tk()"
  end
end
