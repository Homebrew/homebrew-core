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
    sha256 cellar: :any, arm64_tahoe:   "470ac510a2c4129762343393289fa65071a6f1f69274a18e897db5fb8e123df9"
    sha256 cellar: :any, arm64_sequoia: "493a85e0ee00b45d4534ce96d07a09c65f93c650ea2d9256badc39bb10713839"
    sha256 cellar: :any, arm64_sonoma:  "106c220bb1ee721fb10cde87b0535baa745b29df9dd9f9c4d455af2aaaf091a6"
    sha256 cellar: :any, sonoma:        "1c0783f75312bfab9a1d451580855cfdbfba0292c7e933f2dacfb386d18cd443"
    sha256 cellar: :any, arm64_linux:   "8f108754cb35d7b225ad25444e9e81b7091046f962a8be3cbdd3181d0255a306"
    sha256 cellar: :any, x86_64_linux:  "21bf69d4e87a35ac77d989e239860f64d1c286aafab8376d29a88c495366aa92"
  end

  # https://devguide.python.org/versions/#versions
  deprecate! date: "2027-11-01", because: :deprecated_upstream
  disable! date: "2028-11-01", because: :deprecated_upstream

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
