class PythonTkAT39 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  # Keep in sync with python@3.9.
  url "https://www.python.org/ftp/python/3.9.5/Python-3.9.5.tar.xz"
  sha256 "0c5a140665436ec3dbfbb79e2dfb6d192655f26ef4a29aeffcb6d1820d716d83"
  license "Python-2.0"

  livecheck do
    url "https://www.python.org/ftp/python/"
    regex(%r{href=.*?v?(3\.9(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "add34b7058f6f0652b2ed8ad4d885f923dc4cfe09413d2b64e808200b663a935"
    sha256 cellar: :any, big_sur:       "4c43cb24ef73143fb457db087ebeaa180017f63073e6ab691fd0fc45f1b728c9"
    sha256 cellar: :any, catalina:      "93550578b572f2e27ab0a21b96ba8aa24849a8d62cb41e82e233d08ebb3e25ca"
    sha256 cellar: :any, mojave:        "91932629bcd452735cd840248bfe1ce52ffdbabb7aba5880ee6c910be2aeb77c"
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
