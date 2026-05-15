class PythonTkAT314 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.14.5/Python-3.14.5.tgz"
  sha256 "9c22bfe9939a6c5418fc74b289a5f1cc41859ae82ac6b163016b5844bd0a86bc"
  license "Python-2.0"

  livecheck do
    formula "python@3.14"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5d904446ffb8af46db9d1325b7e3fee4a03e9e0986262887421274aa2f8654c3"
    sha256 cellar: :any, arm64_sequoia: "430434ca9a1b4ee4154d566119fd2a7aa4fbe8275e2e1c99440a5496c3fede4c"
    sha256 cellar: :any, arm64_sonoma:  "ff2101748a0ff5323860d644d42575fa0dd44cbe9d1904851d1abbeeeaf35994"
    sha256 cellar: :any, sonoma:        "460b7770e89ea0e66a5850a61fabaec37057bc7f27e47430c6a66492b005ed53"
    sha256               arm64_linux:   "bb71f18d357c0eac886b29aa3421140a64f6f545a9ce94b46b3e72221fab5ae0"
    sha256               x86_64_linux:  "1d2c3cd8f5e66d1cc58f463d25d75642507fc363627220a14bdcb3abdc91bfa1"
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
