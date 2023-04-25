class PythonTkAT311 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.3/Python-3.11.3.tgz"
  sha256 "1a79f3df32265d9e6625f1a0b31c28eb1594df911403d11f3320ee1da1b3e048"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f6708af02bed6b0cd9d50857f6d8f2cdcf871ce9df6cd70abf313dc40339ce3b"
    sha256 cellar: :any,                 arm64_monterey: "8fb0f910e3b867033f8cfa2d020e16916ac5cf42265547c7feae2689c280661d"
    sha256 cellar: :any,                 arm64_big_sur:  "cb11e63b8d327778fda56ee5b4b9532acba63fc9c6815b8f72c6ceceeadb51d2"
    sha256 cellar: :any,                 ventura:        "31b058ac9d2c59aa00565d71db4875f9e699e8df06385046f884b66b0415b6c7"
    sha256 cellar: :any,                 monterey:       "57e88e5663876ed9731b8252a0b32c5c1424b64b9fd671db96de0023b28551b8"
    sha256 cellar: :any,                 big_sur:        "7563ac9105fb9af4e1ff20a9b0fa518d4b6ac05b608438b3c086918a64d132b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c48eee7b624dc9d103a01f980f181c5870a5f874455f443bb1e104dbca7182d"
  end

  depends_on "python@3.11"
  depends_on "tcl-tk"

  def python3
    "python3.11"
  end

  def install
    cd "Modules" do
      tcltk_version = Formula["tcl-tk"].any_installed_version.major_minor
      (Pathname.pwd/"setup.py").write <<~EOS
        from setuptools import setup, Extension

        setup(name="tkinter",
              description="#{desc}",
              version="#{version}",
              ext_modules = [
                Extension("_tkinter", ["_tkinter.c", "tkappinit.c"],
                          define_macros=[("WITH_APPINIT", 1)],
                          include_dirs=["#{Formula["tcl-tk"].opt_include/"tcl-tk"}"],
                          libraries=["tcl#{tcltk_version}", "tk#{tcltk_version}"],
                          library_dirs=["#{Formula["tcl-tk"].opt_lib}"])
              ]
        )
      EOS
      system python3, *Language::Python.setup_install_args(libexec, python3),
                      "--install-lib=#{libexec}"
      rm_r libexec.glob("*.egg-info")
    end
  end

  test do
    system python3, "-c", "import tkinter"

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system python3, "-c", "import tkinter; root = tkinter.Tk()"
  end
end
