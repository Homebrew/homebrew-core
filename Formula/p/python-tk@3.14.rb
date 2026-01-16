class PythonTkAT314 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.14.2/Python-3.14.2.tgz"
  sha256 "c609e078adab90e2c6bacb6afafacd5eaf60cd94cf670f1e159565725fcd448d"
  license "Python-2.0"

  livecheck do
    formula "python@3.14"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8fe0f17b8b79b2e972b8f32d41158abd0a1d23fb0368b6f7a68fe353801a7e42"
    sha256 cellar: :any, arm64_sequoia: "53fb21c4024bf8d5cfc8f11831eafdacfcc438c48971239f63c9553d3b24ad18"
    sha256 cellar: :any, arm64_sonoma:  "4b4a810f4e20506d736e91940ce3af7c72630b85ec013d380e10d263625f6ffb"
    sha256 cellar: :any, sonoma:        "98b915d673d529e5913ca1ab348a3efa7af808c3544c4d073016fbbdaf9ac1ef"
    sha256               arm64_linux:   "2cf6f84d2164ea7d1cca3e2403069d874c96444ff77de1c46d78d71a991f8e64"
    sha256               x86_64_linux:  "4061ccf4ce3a29a709b5a6a5cbba1ed877c3193bbc03ec359c254bdc0f0ccb13"
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
