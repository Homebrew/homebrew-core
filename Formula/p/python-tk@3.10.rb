class PythonTkAT310 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.10.14/Python-3.10.14.tgz"
  sha256 "cefea32d3be89c02436711c95a45c7f8e880105514b78680c14fe76f5709a0f6"
  license "Python-2.0"

  livecheck do
    formula "python@3.10"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "eab4f85a507614392363f2705884baaa355e61733d6e9fe6e4047fda518941b2"
    sha256 cellar: :any,                 arm64_ventura:  "142e2c05a6bafe287b5bbe0442b3c7987f0d031ca46b6646cd164bfbe5fc0115"
    sha256 cellar: :any,                 arm64_monterey: "a7e71d0cc888c025be7356593656571afc280c4d0acbeaa6c503eeb40211a9e0"
    sha256 cellar: :any,                 sonoma:         "4582ff8ebe562049ac5d5052295620bf312e50e2fe3631f5079200adfe441bf1"
    sha256 cellar: :any,                 ventura:        "9d281e192995af91cf001e68a5a95950cd2b089b56cc8a58a3ff3f1c761a69eb"
    sha256 cellar: :any,                 monterey:       "a435c9b37522c57fae99691c34d045f6778da7ca2c342ebdaa0a0422a8261a71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a109110be289f8b1b6393c1915f12399a037820fb1aef89ff6f851a4a3d7352"
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
