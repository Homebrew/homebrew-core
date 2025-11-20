class PythonTkAT314 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.14.0/Python-3.14.0.tgz"
  sha256 "88d2da4eed42fa9a5f42ff58a8bc8988881bd6c547e297e46682c2687638a851"
  license "Python-2.0"

  livecheck do
    formula "python@3.14"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "284cf632a3596aaacb14b1ef56be29610c5052e93d780c808f567ab8593bbd01"
    sha256 cellar: :any, arm64_sequoia: "212ee18acee1f8510fceb7ec11a6b572d9764e0293aef1ebe66a0560e572a4d0"
    sha256 cellar: :any, arm64_sonoma:  "8458bb7ec90e51b6b78fb718330826050112ae8d061c3c46b3bc96d227b35428"
    sha256 cellar: :any, sonoma:        "d342b8b1a74c6902c1cff925b165780473076fed0aeb2b4e067ca228e434fddf"
    sha256               arm64_linux:   "ed95e44bcb768cb3e1f4f6e2c86f59cd808e49fb07a443875d67e2388803b0c2"
    sha256               x86_64_linux:  "42e07cd8bbd7f98ca193f92ed91b023cfa0d71fac91eb7ebec5dc0964cbbe6c5"
  end

  depends_on "python@3.14"
  depends_on "tcl-tk"

  def python3
    "python3.14"
  end

  # Apply commit from open PR to fix TCL 9 threaded detection
  # PR ref: https://github.com/python/cpython/pull/128103
  patch do
    url "https://github.com/python/cpython/commit/a2019e226e4650cef35ebfde7ecd7ce044a4a670.patch?full_index=1"
    sha256 "03c4b6a293d4a51f534858657717bdc1465c42acb3b78e64c41f9011f966e449"
  end

  def install
    xy = Language::Python.major_minor_version python3
    python_include = if OS.mac?
      Formula["python@#{xy}"].opt_frameworks/"Python.framework/Versions/#{xy}/include/python#{xy}"
    else
      Formula["python@#{xy}"].opt_include/"python#{xy}"
    end

    cd "Modules" do
      tcltk_version = Formula["tcl-tk"].any_installed_version.major_minor
      Pathname("setup.py").write <<~PYTHON
        from setuptools import setup, Extension

        setup(name="tkinter",
              description="#{desc}",
              version="#{version}",
              ext_modules = [
                Extension("_tkinter", ["_tkinter.c", "tkappinit.c"],
                          define_macros=[("WITH_APPINIT", 1), ("TCL_WITH_EXTERNAL_TOMMATH", 1)],
                          include_dirs=["#{python_include}/internal", "#{Formula["tcl-tk"].opt_include/"tcl-tk"}"],
                          libraries=["tcl#{tcltk_version}", "tcl#{tcltk_version.major}tk#{tcltk_version}"],
                          library_dirs=["#{Formula["tcl-tk"].opt_lib}"])
              ]
        )
      PYTHON
      system python3, "-m", "pip", "install", *std_pip_args(prefix: false, build_isolation: true),
                                              "--target=#{libexec}", "."
      rm_r libexec.glob("*.dist-info")
    end
  end

  test do
    system python3, "-c", "import tkinter"

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system python3, "-c", "import tkinter; root = tkinter.Tk()"
  end
end
