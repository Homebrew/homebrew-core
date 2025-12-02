class PythonTkAT39 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.9.25/Python-3.9.25.tar.xz"
  sha256 "00e07d7c0f2f0cc002432d1ee84d2a40dae404a99303e3f97701c10966c91834"
  license "Python-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "605652d4b416da946391152dfff95e132051024b39f5bf92874d1c4e7df1bb16"
    sha256 cellar: :any,                 arm64_sequoia: "15e8153bd95f1440bb888f1e7e944558edde77901a1b0057bdf4ab5645080b1d"
    sha256 cellar: :any,                 arm64_sonoma:  "4675b5a8cf5c110f06ee19c2afa43df40930a1ce25f8785c7b003ba538ce7cce"
    sha256 cellar: :any,                 sonoma:        "6a713e912309d33e7155769d2c9a5bf900182b6b9403696b11646fc49cbefb15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "768e2164044eccdbbb7b436a3f94b9adee9f100311c0994827b6a7cc5afaffcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4035a740833fc798719765d1124ceca0c5d5652091befb81f6de94d91d9b34d0"
  end

  # Follow up to python@3.9 deprecation
  deprecate! date: "2025-10-15", because: :deprecated_upstream
  disable! date: "2026-10-15", because: :deprecated_upstream

  depends_on "python@3.9"
  depends_on "tcl-tk@8"

  def python3
    "python3.9"
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
