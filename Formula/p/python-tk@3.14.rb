class PythonTkAT314 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.14.6/Python-3.14.6.tgz"
  sha256 "74d0d71d0600e477651a077101d6e62d1e2e69b8e992ba18c993dd643b7ba222"
  license "Python-2.0"

  livecheck do
    formula "python@3.14"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "db91272cb60b7f0121c8cb2a92c853310b3428999cb7abb4b86c8e544fe54fef"
    sha256 cellar: :any, arm64_sequoia: "c4be42c490067ea6f5c6d6f2c6fd39d4ef30bb60d169ff3c05c658194a939b5e"
    sha256 cellar: :any, arm64_sonoma:  "3d13772060aacaaac4119c2e558b236a4f8401806743965054ef594e7143350d"
    sha256 cellar: :any, sonoma:        "f2313272bbcdba1f0f1a51b4e8737891c6d3c93587e64d4ef133916cadf53853"
    sha256               arm64_linux:   "31ffdee6d72bcaaffb178bcc1de166014ae67d1760f99da3f4756a521edf51fa"
    sha256               x86_64_linux:  "af2eb8c451104069ebf7e6f4c919af096bf3a1c6c684e29ba1ebb65cbcbadedb"
  end

  depends_on "python@3.14"
  depends_on "tcl-tk"

  def python3
    "python3.14"
  end

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

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system python3, "-c", "import tkinter; root = tkinter.Tk()"
  end
end
