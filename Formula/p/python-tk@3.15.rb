class PythonTkAT315 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.15.2/Python-3.15.2.tgz"
  sha256 "f74e1db0eabd651cd01e4e2a00201bd41866abe74869ab716f9bf33cbbaa0943"
  license "Python-2.0"

  livecheck do
    formula "python@3.15"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "666d1266f790f741951d03b54b138d8a9fb7eade02b549c49d363fc7012353e0"
    sha256 cellar: :any, arm64_tahoe:       "334c1f60479962b5c992c2c539d6c7a1200b20d11e5e197849c2ebfa92c1a5e7"
    sha256 cellar: :any, arm64_sequoia:     "e909687eca8d310f4fdfdb3ec29ffcd3fad90f544afdfc28e0560d571221cff0"
    sha256               arm64_linux:       "bcc14a32bc04bef88fefcae46ed5ab2a611c0797012fbdc7d1b9ce11fdf9eac2"
    sha256               x86_64_linux:      "70c16eac15d3276ce64448fb58265509550665cf6398594722840dd10b1de93b"
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
