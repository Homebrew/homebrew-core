class PythonTkAT39 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.9.21/Python-3.9.21.tar.xz"
  sha256 "3126f59592c9b0d798584755f2bf7b081fa1ca35ce7a6fea980108d752a05bb1"
  license "Python-2.0"

  livecheck do
    formula "python@3.9"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fb59226aeb7699594a047fe6c42f157e521da7f49c26c07e1b9bb5624686895a"
    sha256 cellar: :any,                 arm64_sonoma:  "a4bbc190a6544a0cb74ab170ae393867a058d9e96d0d475c5851e91da5ce6d3c"
    sha256 cellar: :any,                 arm64_ventura: "96e09d1a79763947368078644f5984916d060b8944a210ae9c6f41b9f58cbe44"
    sha256 cellar: :any,                 sonoma:        "8acf48a0817bf804e05cf5851b2a28654cc27d48b39551e8769c05393244d8d8"
    sha256 cellar: :any,                 ventura:       "ec7efc1e06585523aa258d106ec5e32799b0bcf9ddad9a7c2aecfabda2253f0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c75b7774a3bac81fe4322cf5e2aa9b5fbc671ce284ffded637d07cfe4dfd920"
  end

  depends_on "python@3.9"
  depends_on "tcl-tk@8"

  def python3
    "python3.9"
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
