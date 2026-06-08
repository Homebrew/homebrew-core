class PythonTkAT311 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.15/Python-3.11.15.tgz"
  sha256 "f4de1b10bd6c70cbb9fa1cd71fc5038b832747a74ee59d599c69ce4846defb50"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9d4c3595e2ea5d5cd9023119821ef0bd2a0de04e95747f61afee97c37163222a"
    sha256 cellar: :any,                 arm64_sequoia: "4ba4218e08f4544b714d7a1985390c4774de9dc3c10c55ddd135d285bbe9fc99"
    sha256 cellar: :any,                 arm64_sonoma:  "acfb91bc8ba2025471a0d707549b0ac30fed7dcdbd23f2256b5905c1c43ab008"
    sha256 cellar: :any,                 sonoma:        "b5e63b585151fdf740650d132c819c8d536ad515dae9adc2ea4dca3168b2d912"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dcf8018fd89bb9e1341e8aa2cbebbe4a6f738e244a64d1db71c587a63e87d9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd083f95a984b7d674e4399acbe1278ebfa44653de01af5789dd59f8f6e33801"
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
