class PythonTkAT310 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.10.18/Python-3.10.18.tgz"
  sha256 "1b19ab802518eb36a851f5ddef571862c7a31ece533109a99df6d5af0a1ceb99"
  license "Python-2.0"

  livecheck do
    formula "python@3.10"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1f71b66d08ecc36332a7c98a093c13ba771584256859cd2a7b4dd609cbd2f62a"
    sha256 cellar: :any,                 arm64_sonoma:  "597d8fdc4278dd17026d5f190c779d17fd5afff09f297902e98350371f37ff97"
    sha256 cellar: :any,                 arm64_ventura: "47517511a709811f900ef3659698be6c2fd17af904878f2091304f257c13cdd5"
    sha256 cellar: :any,                 sonoma:        "85c5b1383e410c1e54b5d07c386b9041381c51ff07724081f05e6f78f2809406"
    sha256 cellar: :any,                 ventura:       "1181b2988faa56016526ad6a304b876d76a10f562b30cbedcd52c0cb29b3319c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3dda7d8fd49b12103441387e348e98590f634a550fa7687fa31f2d86809c630"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e2a4c5cec43887c789c02fd4ea7dc1c44e9d3313066d625eb0533706fd157e3"
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
