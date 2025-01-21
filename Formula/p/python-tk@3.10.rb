class PythonTkAT310 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.10.16/Python-3.10.16.tgz"
  sha256 "f2e22ed965a93cfeb642378ed6e6cdbc127682664b24123679f3d013fafe9cd0"
  license "Python-2.0"

  livecheck do
    formula "python@3.10"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "68b53352f7459667a68d2e2723e6725ddc959ac29dcad81b81be71a3bd5217b5"
    sha256 cellar: :any,                 arm64_sonoma:  "af5c33f6acdbca5647aec3d7cd970ef27f886826d65bc9f8ddc12f7e75736133"
    sha256 cellar: :any,                 arm64_ventura: "f535d3a5b6750eb99547e9009f867beb1382b6c0c8b34c2f15154f8caef50ca4"
    sha256 cellar: :any,                 sonoma:        "ff419e01411af9b9704180232c998269c6ab33756705301ccd341cd4c5ce5d28"
    sha256 cellar: :any,                 ventura:       "0cb43e607c7335bffb65a04c72ac2fe7cf371bd7cd240f1c75b4a534088a2baf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "133d60721b40d030951ae481e497ae9fadf515911a18311a245d643239d82212"
  end

  keg_only :versioned_formula

  depends_on "python@3.10"
  depends_on "tcl-tk@8"

  def python3
    "python3.10"
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
