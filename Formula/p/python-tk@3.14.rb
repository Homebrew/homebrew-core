class PythonTkAT314 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.14.7/Python-3.14.7.tgz"
  sha256 "62859805f6fdf25e2bcbf3fa3217801e1996887ca33e6a2af80674bdfa2dbe07"
  license "Python-2.0"

  livecheck do
    formula "python@3.14"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "5082249275d281c95be90e0d438be8473bb818ad9791627b95ae7766afd953ef"
    sha256 cellar: :any, arm64_tahoe:       "b4a27f6c612e9febd2673efd0eb0473c5235461d436d0bbf374dbdde6d89953d"
    sha256 cellar: :any, arm64_sequoia:     "3221c170c6190048ac547c132d803bc941ef5586d9fa2368d5ff9e3f25caa658"
    sha256               arm64_linux:       "905c0412c969b3b83477cfded8bb828400a208256d1bd19e9e2e6a2b92624781"
    sha256               x86_64_linux:      "abe87ec9ad9d3bb4c66be34974366a8896691abf79b7ca55d99c166bb752f5d3"
  end

  # https://devguide.python.org/versions/#versions
  deprecate! date: "2030-11-01", because: :deprecated_upstream
  disable! date: "2031-11-01", because: :deprecated_upstream

  depends_on "python@3.14"
  depends_on "tcl-tk"

  def install
    xy = Language::Python.major_minor_version python3
    python_include = if OS.mac?
      Formula["python@#{xy}"].opt_frameworks/"Python.framework/Versions/#{xy}/include/python#{xy}"
    else
      formula_opt_include("python@#{xy}")/"python#{xy}"
    end

    tcltk_version = Formula["tcl-tk"].any_installed_version.major_minor
    (buildpath/"Modules/pyproject.toml").write <<~TOML
      [project]
      name = "tkinter"
      version = "#{version}"
      description = "#{desc}"

      [tool.setuptools]
      packages = []

      [[tool.setuptools.ext-modules]]
      name = "_tkinter"
      sources = ["_tkinter.c", "tkappinit.c"]
      define-macros = [["WITH_APPINIT", "1"], ["TCL_WITH_EXTERNAL_TOMMATH", "1"]]
      include-dirs = ["#{python_include}/internal", "#{formula_opt_include("tcl-tk")/"tcl-tk"}"]
      libraries = ["tcl#{tcltk_version}", "tcl#{tcltk_version.major}tk#{tcltk_version}"]
      library-dirs = ["#{formula_opt_lib("tcl-tk")}"]
    TOML
    system python3, "-m", "pip", "install", *std_pip_args(prefix: false, build_isolation: true),
                                            "--target=#{libexec}", "./Modules"
    rm_r libexec.glob("*.dist-info")
  end

  test do
    system python3, "-c", "import tkinter"
  end
end
