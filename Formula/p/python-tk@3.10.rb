class PythonTkAT310 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.10.21/Python-3.10.21.tgz"
  sha256 "f276987f06270ae6c1fb4da620bd105edf78c31368c2f7e85e6c1d51c560b04b"
  license "Python-2.0"

  livecheck do
    formula "python@3.10"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "750913d80d2bdc75e9e53a52be0ab0df18975e3f93d16d83f650528585be4143"
    sha256 cellar: :any, arm64_sequoia: "accc77cc884a47238898b8cc06c71a1bd654fcf8aac8bce900e4b9f4a2ce4352"
    sha256 cellar: :any, arm64_sonoma:  "de8cc83b26d6295db079b94403edef6e4d19013ea273ba72a2340eaf164313e5"
    sha256 cellar: :any, sonoma:        "fdd86c39cc068b59142e4b6921d761564cbd7797d99edf29175a30a87545812a"
    sha256 cellar: :any, arm64_linux:   "098cf1043f95ad67a285b0dfd8ac65645b67ab68bace44eb8b3acf368df85a35"
    sha256 cellar: :any, x86_64_linux:  "abcee4bb35f9fa9a004a9f4ca06ac312fc13e86f0ac188f942513f9602388528"
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
