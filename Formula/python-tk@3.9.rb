class PythonTkAT39 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.9.8/Python-3.9.8.tar.xz"
  sha256 "675ce09bf23c09836bf1969b744b1ea4c1a18c32788626632525f08444ebad5c"
  license "Python-2.0"

  livecheck do
    formula "python@3.9"
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "c3442319da58caa730448b84108d0d61def2f6fed4ec647c4d25bcaf484bf664"
    sha256 cellar: :any, arm64_big_sur:  "ce723268cb8c5b1ac1552330456909eb4be0951ba0d21da7601109e8ff0933fe"
    sha256 cellar: :any, monterey:       "a965cd39d04e6a36777ceecaa348147c5ecc23e86a9937613359389398c4ee15"
    sha256 cellar: :any, big_sur:        "8b4a09f8cd730a220a73cc5e195f3475d96134c28a6da3c1dda55d19719138db"
    sha256 cellar: :any, catalina:       "98132d646c6825f778d995109063bc2faf13456db0e14a3d029ae55465f94198"
    sha256               x86_64_linux:   "10800552438e7fed0ae6a51055ab11f10860f87403099e4c54f971fa04acbfca"
  end

  depends_on "python@3.9"
  depends_on "tcl-tk"

  def install
    cd "Modules" do
      tcltk_version = Formula["tcl-tk"].any_installed_version.major_minor
      (Pathname.pwd/"setup.py").write <<~EOS
        from setuptools import setup, Extension

        setup(name="tkinter",
              description="#{desc}",
              version="#{version}",
              ext_modules = [
                Extension("_tkinter", ["_tkinter.c", "tkappinit.c"],
                          define_macros=[("WITH_APPINIT", 1)],
                          include_dirs=["#{Formula["tcl-tk"].opt_include}"],
                          libraries=["tcl#{tcltk_version}", "tk#{tcltk_version}"],
                          library_dirs=["#{Formula["tcl-tk"].opt_lib}"])
              ]
        )
      EOS
      system Formula["python@3.9"].bin/"python3", *Language::Python.setup_install_args(libexec),
                                                  "--install-lib=#{libexec}"
      rm_r Dir[libexec/"*.egg-info"]
    end
  end

  test do
    system Formula["python@3.9"].bin/"python3", "-c", "import tkinter"

    on_linux do
      # tk does not work in headless mode
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    system Formula["python@3.9"].bin/"python3", "-c", "import tkinter; root = tkinter.Tk()"
  end
end
