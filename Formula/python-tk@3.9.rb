class PythonTkAT39 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  # Keep in sync with python@3.9.
  url "https://www.python.org/ftp/python/3.9.6/Python-3.9.6.tar.xz"
  sha256 "397920af33efc5b97f2e0b57e91923512ef89fc5b3c1d21dbfc8c4828ce0108a"
  license "Python-2.0"

  livecheck do
    formula "python@3.9"
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d727a4202e222fd1bf7a0fcb48b7918d5111219a70e98662a37601ea43e2719a"
    sha256 cellar: :any, big_sur:       "22c5df8dd343a1747980efc5c737f66ea9a811da6bdfd4372d4fe037d6169f90"
    sha256 cellar: :any, catalina:      "eddf535a459aa0e57e6460558e4e34e834e13281654222d4fe2903fbf6835c2c"
    sha256 cellar: :any, mojave:        "090d2bebf38f11b24b688914a1e1eda44361c25eedb4c8be577ccd71bfae50d4"
    sha256               x86_64_linux:  "527a54e82a8f032fd54714ec6ddc6748eb28d0cab0801476cd4f1c7f5c15ae0e"
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
