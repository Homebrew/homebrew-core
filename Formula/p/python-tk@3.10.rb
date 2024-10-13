class PythonTkAT310 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.10.15/Python-3.10.15.tgz"
  sha256 "a27864e5ba2a4474f8f6c58ab92ff52767ac8b66f1646923355a53fe3ef15074"
  license "Python-2.0"

  livecheck do
    formula "python@3.10"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b5dbb1ded91e663c20c3de0e5c2785332633095b48e13316369a683cf7c26eb3"
    sha256 cellar: :any,                 arm64_sonoma:   "48ad8d54f4e0cdf0112d7af29c7ae8477bc636a298464b122016359d7fde5361"
    sha256 cellar: :any,                 arm64_ventura:  "16db2ba9fc83f08baea56726c3f73fa6ed618b049593c72e5c0caccd68e5588d"
    sha256 cellar: :any,                 arm64_monterey: "5f11a8483cb9934671522a9f7785f0dab137dc23a86c9af1d292419efcc66c72"
    sha256 cellar: :any,                 sonoma:         "35e19ce66c25923835b2b3451917f032f1df24131db3addc22b72e61c0c29559"
    sha256 cellar: :any,                 ventura:        "d3f7f38c344f9be77e906d6ff7209693e19e298bf5d7c53e6a2f6c23be956640"
    sha256 cellar: :any,                 monterey:       "f7c599e378442e0be4d1ffb392616d8e251a58deeee6be7bb0c1cbb4bd01f5f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbb8a51c62004b176e0a95d51bf3426fcbe88f01f6cb520bd4dc235dbc537b6c"
  end

  keg_only :versioned_formula

  depends_on "python@3.10"
  depends_on "tcl-tk"

  def python3
    "python3.10"
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
