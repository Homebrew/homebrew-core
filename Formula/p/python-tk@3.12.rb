class PythonTkAT312 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.12.16/Python-3.12.16.tgz"
  sha256 "710c3e75dac8b2f258d9cd0f76e5c4c2e9175fac9e249c98901552f7cf33b7dd"
  license "Python-2.0"

  livecheck do
    formula "python@3.12"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1ae2665d755fdabe486520abf29166abc4dc396fd2e97178afca8e506ee5e212"
    sha256 cellar: :any, arm64_tahoe:       "4ac87c4866deaf415263f9f0174d2ce3f5bb3e620df1e3c5f1ed6f01dcf3778c"
    sha256 cellar: :any, arm64_sequoia:     "ab60e6a0dfa41f7d56656bc0cfc929959a00d75d84f253c9c8fab008bfbc9276"
    sha256               arm64_linux:       "8b5bc05c824cea71e90aeac173cb86658a51506edab967ec56e9f5707c43eb10"
    sha256               x86_64_linux:      "616d47082dcb781f3486e2099213ddb62f4d3f55f58bc12f9aa98a2faf8f92e8"
  end

  # https://devguide.python.org/versions/#versions
  deprecate! date: "2028-11-01", because: :deprecated_upstream
  disable! date: "2029-11-01", because: :deprecated_upstream

  depends_on "python@3.12"
  depends_on "tcl-tk"

  # Apply commit from open PR to fix TCL 9 threaded detection
  patch do
    url "https://github.com/python/cpython/commit/a2019e226e4650cef35ebfde7ecd7ce044a4a670.patch?full_index=1"
    sha256 "03c4b6a293d4a51f534858657717bdc1465c42acb3b78e64c41f9011f966e449"
    type :backport
    resolves "https://github.com/python/cpython/pull/128103"
  end

  # Backport of https://github.com/python/cpython/commit/47cbf038850852cdcbe7a404ed7c64542340d58a
  patch do
    file "Patches/python-tk/tcl9.diff"
    type :backport
  end

  def install
    xy = Language::Python.major_minor_version python3
    python_include = if OS.mac?
      Formula["python@#{xy}"].opt_frameworks/"Python.framework/Versions/#{xy}/include/python#{xy}"
    else
      formula_opt_include("python@#{xy}")/"python#{xy}"
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
                          include_dirs=["#{python_include}/internal", "#{formula_opt_include("tcl-tk")/"tcl-tk"}"],
                          libraries=["tcl#{tcltk_version}", "tcl#{tcltk_version.major}tk#{tcltk_version}"],
                          library_dirs=["#{formula_opt_lib("tcl-tk")}"])
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
  end
end
