class PythonTkAT310 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.10.20/Python-3.10.20.tgz"
  sha256 "4ff5fd4c5bab803b935019f3e31d7219cebd6f870d00389cea53b88bbe935d1a"
  license "Python-2.0"

  livecheck do
    formula "python@3.10"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c5b7ebf5aa4eee41ed74526a1f5df037f13bfa83f258f8b4fb7f3b30b3a31da8"
    sha256 cellar: :any,                 arm64_sequoia: "a1ce7593863791c5787d9f763e8a3c137434c00f7bcda6c636dbe92c3d007b82"
    sha256 cellar: :any,                 arm64_sonoma:  "3586decc40d9b1cfff773d46c7c29a3014f21f1fe641c96bd96462fd76ca2598"
    sha256 cellar: :any,                 sonoma:        "8b510d6efa0411c1edf47448e6a25c619c0e5a6fd836a86dc7bb97f7b26da05b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7931159f029a33ee29f6bc71f0b3252ec32ce025285004a51111c5be5b70bcc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1e7c94c4c5f549a657817e444191f033cb8aa7e33e4398569b062a2b62bf89f"
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
