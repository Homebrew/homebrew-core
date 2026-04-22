class PythonTkAT314 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.14.4/Python-3.14.4.tgz"
  sha256 "b4c059d5895f030e7df9663894ce3732bfa1b32cd3ab2883980266a45ce3cb3b"
  license "Python-2.0"

  livecheck do
    formula "python@3.14"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4d4a5c6b6f9706d0af9ed335d83af0c48779689c173f33c7845f125e5fc8fc6c"
    sha256 cellar: :any, arm64_sequoia: "14770a29886ef9a7935aa161f58a1b15ef15fb836772d1ace982173e4e841c50"
    sha256 cellar: :any, arm64_sonoma:  "1977b8df59a7081d5e6bbbb7ae5e7527d6b900d36ec4a361a67f1beb99ecb7b6"
    sha256 cellar: :any, sonoma:        "6cd825bd2a9d84c7f58e06062dcd3f43007bc24d1cf3695dc5d1a340094bfa2f"
    sha256               arm64_linux:   "1bc075f82122de7d70319d2b2cc8cbf5a67f7758f63e68ae5919908986b1126c"
    sha256               x86_64_linux:  "93ba17b7df890864548a602b2820dd7a695dbe0647cc0e75e21953db1850b6eb"
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
      Formula["python@#{xy}"].opt_include/"python#{xy}"
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
      include-dirs = ["#{python_include}/internal", "#{Formula["tcl-tk"].opt_include/"tcl-tk"}"]
      libraries = ["tcl#{tcltk_version}", "tcl#{tcltk_version.major}tk#{tcltk_version}"]
      library-dirs = ["#{Formula["tcl-tk"].opt_lib}"]
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
