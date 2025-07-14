class PythonTkAT39 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.9.23/Python-3.9.23.tar.xz"
  sha256 "61a42919e13d539f7673cf11d1c404380e28e540510860b9d242196e165709c9"
  license "Python-2.0"

  livecheck do
    formula "python@3.9"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b227160ed5aef9c4f7e28e09ea937af589e06bc2d6552fe1c165e81c8d1ccd45"
    sha256 cellar: :any,                 arm64_sonoma:  "8a0e764addd46852b5839650f37eef097d24e19c99934650cdff771293449336"
    sha256 cellar: :any,                 arm64_ventura: "cd59125fba711a0c87f544a4620d3d7b96a8ed7b0ebce5806648505f3f83d6bf"
    sha256 cellar: :any,                 sonoma:        "4b03a3f5cee283613c72237191a9c031d1748513f9be078ae34b130a277f2d38"
    sha256 cellar: :any,                 ventura:       "970a215b6c26de770d34e4d84a92f9601f1a4bf02a54f90cda603a28344fe0c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c8fe4f4651455838a5c2c670c38c48c43e215510286716bd422e97809e305da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4bf36de1aafbde00eed0e09f75c6d0ad0be7d34e7712638a6fead91baec3aad"
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
