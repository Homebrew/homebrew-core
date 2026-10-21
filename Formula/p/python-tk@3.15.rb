class PythonTkAT315 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.15.0/Python-3.15.0.tgz"
  sha256 "438596cac081036d3c1d532ab7e7335eeb35567bc961749a0d5797176db0db68"
  license "Python-2.0"

  livecheck do
    formula "python@3.15"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e372315020497c7f3c4da68dadfea43d9f8dcc12444be2f861b0bd37a2d1a61c"
    sha256 cellar: :any, arm64_tahoe:       "654e10dc8b72b166aa789ad16082a594311f0efedb4e736d733c3a933a6cc086"
    sha256 cellar: :any, arm64_sequoia:     "4d909bb19929b478e9ef206557d0aefa355fa23454536d650194d82b149523cc"
    sha256               arm64_linux:       "1a426cd87a6bedaa8dfafc4d9b6b1e0eaa9080695e73751e1ce3e31c36386513"
    sha256               x86_64_linux:      "1cf732fead9cc132606f8c0395ec31b8f66c01837e67016c994ee2b5a38807c9"
  end

  # https://devguide.python.org/versions/#versions
  deprecate! date: "2031-11-01", because: :deprecated_upstream
  disable! date: "2032-11-01", because: :deprecated_upstream

  depends_on "python@3.15"
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
