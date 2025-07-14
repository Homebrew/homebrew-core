class PythonTkAT311 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.13/Python-3.11.13.tgz"
  sha256 "0f1a22f4dfd34595a29cf69ee7ea73b9eff8b1cc89d7ab29b3ab0ec04179dad8"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "00d379569858f3c1a7107a298d37baac30cba208acacabc2884bcf9b16a42273"
    sha256 cellar: :any,                 arm64_sonoma:  "28ebed5c86e33f724cd22d05cb9f10f5716fbc4ce67abd73b0997e748903e14a"
    sha256 cellar: :any,                 arm64_ventura: "e7fffe5adb99cc11fd60beb06b0c56d8d729f5e5f3f56a8a53a676d4df17715e"
    sha256 cellar: :any,                 sonoma:        "291088d2031b37c50f0e9f8c212766ce94906cd75b7f54d75f6cca54cfcb0831"
    sha256 cellar: :any,                 ventura:       "794fd43eb46a856a211eb43faab76678603a7d5effcb85d7359c2ed93338ee41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c1784b3ea0beca3add3cb6033de9f384c6572d6c41e447752e9ee3e766b66c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e7b2867f47436b3b102c067980f3a5ddd6512f7ad1c57f37b35eacd4bbd7c80"
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
