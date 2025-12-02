class PythonTkAT311 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.14/Python-3.11.14.tgz"
  sha256 "563d2a1b2a5ba5d5409b5ecd05a0e1bf9b028cf3e6a6f0c87a5dc8dc3f2d9182"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b54423a812944469eb095929f91b851e2b0bd95d0c0220a911f377afddb78bf3"
    sha256 cellar: :any,                 arm64_sequoia: "6a0ce386d5b3e473fe149dfff86c75731c66aa1789d2b59a60859ce09dc2a438"
    sha256 cellar: :any,                 arm64_sonoma:  "a93945fa0b4fb66aad07521b8990f5d57a942445586c4cc5b298b35fce1d25d8"
    sha256 cellar: :any,                 sonoma:        "86057239dd2e50c6b833fb17ab12c95906137ae3681f2c6846980217910ec306"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edd82a83b1ef25840c2f2eb963ae126191331019894d70ae858e01195cf44415"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ebb3928e752f424202fdbaff87a3aca61e6b19943224dbca7178c87d942ff2d"
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
