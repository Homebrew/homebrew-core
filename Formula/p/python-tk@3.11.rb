class PythonTkAT311 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.12/Python-3.11.12.tgz"
  sha256 "379c9929a989a9d65a1f5d854e011f4872b142259f4fc0a8c4062d2815ed7fba"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "672aecb6ab1193e4a2dbdfcb3720679b998f012a61bb8c13579881c064b53e65"
    sha256 cellar: :any,                 arm64_sonoma:  "1e80c600dc458c670be96f05e134fcdb0835a1bb0c711e689fdd0ebda486f2f5"
    sha256 cellar: :any,                 arm64_ventura: "55632e676b562fa016c95d109ae0ed7347988a48f1281024f6cfd67df118d63e"
    sha256 cellar: :any,                 sonoma:        "c10a084ec54b28fbb8973128666616335ec7ca3b7a05ca7c5dba46759094cc8f"
    sha256 cellar: :any,                 ventura:       "e99d656fa71673fcdf75badbcab914ab9f156ea322a2ec1049301a1d56856aae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a8e65ca09eca6756e94281113bed781522698102dd42b61fc73f70285651c14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a3388da80f4fee1b80eea795ed2e0f9af2c94b73d8fec91affc1a02e6262bb2"
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
