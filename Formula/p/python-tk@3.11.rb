class PythonTkAT311 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.16/Python-3.11.16.tgz"
  sha256 "6c0bd76ab0ec7d94ed400b1497f01ac6c7751c8822615ee0855a3eb2d893ea76"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "88f68654136cc6c7446ed395ab95f2b8db57a6c1f7266a19dbd5ccf3f427d1ff"
    sha256 cellar: :any, arm64_tahoe:       "075ac4b075b1a5b45b89b66929dfd204c975091271dace4d2d9ec6aeb7b9b0c2"
    sha256 cellar: :any, arm64_sequoia:     "7725995c2a79d56bc9e57c9a6d91967554ac01f0a6c72f8080f4135e5cd428c1"
    sha256 cellar: :any, arm64_linux:       "c509298633167da5d61eaf348f7a2305f4562b7e4c2d5e73ec342defba4c9f75"
    sha256 cellar: :any, x86_64_linux:      "fb5bda6343cf3b8a5ca4f1d2001c81dfc4355a7940f6a749d22ffb5530bc14e7"
  end

  # https://devguide.python.org/versions/#versions
  deprecate! date: "2027-11-01", because: :deprecated_upstream
  disable! date: "2028-11-01", because: :deprecated_upstream

  depends_on "python@3.11"
  depends_on "tcl-tk@8"

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
