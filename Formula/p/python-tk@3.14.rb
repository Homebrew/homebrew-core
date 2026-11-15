class PythonTkAT314 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.14.10/Python-3.14.10.tgz"
  sha256 "9e4996c19ae5a3df31f10c37723661f71d3455d73bd005f79df7098e5cc13192"
  license "Python-2.0"

  livecheck do
    formula "python@3.14"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c74bc9b010d0c1d2f289748e3240c4e4d51e16fc21a211748abdabc95651f044"
    sha256 cellar: :any, arm64_tahoe:       "49566822b55b9e97807a03ac9dc822721ecb75b580305e41bdd3186f0450d579"
    sha256 cellar: :any, arm64_sequoia:     "e935259b4037dff9e4210661431a131dd7ace1e130d11f9fdaaccb8b5d070a97"
    sha256               arm64_linux:       "40f407cf9897886dfaf17689982724b9f7411e5bf290e5d85cb2164743c468b6"
    sha256               x86_64_linux:      "6178c4db46935e9f3d9b4578f55e93f7987b527d1fa18046dd252964a3f3be6d"
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
