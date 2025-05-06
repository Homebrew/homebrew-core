class PythonTkAT310 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.10.17/Python-3.10.17.tgz"
  sha256 "8fcda0fbdc131859a4a4223abb925fd522a77e3fb3b52c46cea5f3bc2ae0cd9f"
  license "Python-2.0"

  livecheck do
    formula "python@3.10"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4a01d642ccdc00918edf1d1d7b98ed2f16cfe51d33b7e71c32fec64563bb5879"
    sha256 cellar: :any,                 arm64_sonoma:  "620622c1b79a62e6b44917024469937e773f99ac7c4f6386de3a1036e27ef749"
    sha256 cellar: :any,                 arm64_ventura: "c6bc2fa3384949b69cfc44a4e3b0db03717e3ff319b06145ff2ce631ad66a1d9"
    sha256 cellar: :any,                 sonoma:        "29de8774c5638894b20592447ca8812b0982c0eae4e2abaeda961223711f459f"
    sha256 cellar: :any,                 ventura:       "26c2e7c3e1f958bc89a3bedbc6011aa20d8bfff502d8a88b973ff7363baae17c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d039a25172dfd16b51a49eb019a9710cf537255cf4f194d68b83e684ee067724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a8c2852664e43e4ea79488192dbd32d22aae7f9304c77d59f366ef57bbf891a"
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
