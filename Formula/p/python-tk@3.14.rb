class PythonTkAT314 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.14.3/Python-3.14.3.tgz"
  sha256 "d7fe130d0501ae047ca318fa92aa642603ab6f217901015a1df6ce650d5470cd"
  license "Python-2.0"

  livecheck do
    formula "python@3.14"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "68e28a3074ff17c97b1aaa4764612b4e0e0307ad58e04bd0841645ed5de1690b"
    sha256 cellar: :any, arm64_sequoia: "7fcf823c255f6634c12c7f7bd9bb32f78f5cb587c856910b76e1f6818adc2436"
    sha256 cellar: :any, arm64_sonoma:  "1d8c830f5228840322cc1ddc90c2e7e70c0944298ee3f69d09ee6da683e685d2"
    sha256 cellar: :any, sonoma:        "291ef83eb21e61b78b4ad25f5072051218149ab88ca61a70ce7aa99e5d0f4e21"
    sha256               arm64_linux:   "6270532a3dd7a26c1b876b2e7eea8624ab850d6583f2678e3eb9ce0f62418364"
    sha256               x86_64_linux:  "b6a63fdbe3529e3871451cb4ca18d4743d9632d00ffa92b3f765278133ae53fc"
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
