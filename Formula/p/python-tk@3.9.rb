class PythonTkAT39 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.9.22/Python-3.9.22.tar.xz"
  sha256 "8c136d199d3637a1fce98a16adc809c1d83c922d02d41f3614b34f8b6e7d38ec"
  license "Python-2.0"

  livecheck do
    formula "python@3.9"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "97ff0ebb45169ef1ff0c84f9a371a26366c1f7d5dcbdd44731d7aafef909dbdf"
    sha256 cellar: :any,                 arm64_sonoma:  "bee7e5c80ede81876ed8f19d5162558d1800860d9f4c921b05e70f715f086848"
    sha256 cellar: :any,                 arm64_ventura: "8f0e72d74b73201b8e4308472f0e62cc472a2c857fc4530281d6f4cd1073b8be"
    sha256 cellar: :any,                 sonoma:        "2bd134ab988daff8d742f16f1d7812797d3768923329e09bad20a1ec869fe046"
    sha256 cellar: :any,                 ventura:       "6dde244305b1c4422d73cb4cfa89d074b17ad6fa66c2b47c1ea0a8b80c10c690"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8a69bf13e7d5218ce7454239a7a4841dc2f49ed9ecafa528e1a22b29145da55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c022b1b83102ca8f5d347c378d210034f881fcdd8de06d9dee2204c3fbec851b"
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
