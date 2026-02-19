class PythonTkAT310 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.10.19/Python-3.10.19.tgz"
  sha256 "a078fb2d7a216071ebbe2e34b5f5355dd6b6e9b0cd1bacc4a41c63990c5a0eec"
  license "Python-2.0"

  livecheck do
    formula "python@3.10"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2ba7645c83ffe837d1310a83f08cb920dc8eb3884bfa2f62f66a434746dc9e91"
    sha256 cellar: :any,                 arm64_sequoia: "014bf0672e61b43b3c9c42b777d642c485ce637a8700272ca088c659dae5b190"
    sha256 cellar: :any,                 arm64_sonoma:  "4279255fcae24b936d68a3bb10e42b2e34fe8a4fc37646d2ad1289d083864d15"
    sha256 cellar: :any,                 sonoma:        "c33e7e0f2f9159ef4facf7882105e15334195ea75d6b7778d33be6541b8d09c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea2a876610f29fafaed5f569d5d8f28eb560687f204d88fddf152fa30cd548b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c8d7cc10aa2657beb4b197992c97ed9eb3b7a1252317bda2cfc24783d12d7b2"
  end

  keg_only :versioned_formula

  # https://devguide.python.org/versions/#versions
  deprecate! date: "2026-10-15", because: :deprecated_upstream
  disable! date: "2027-10-15", because: :deprecated_upstream

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
