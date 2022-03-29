class PythonTkAT310 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.10.2/Python-3.10.2.tgz"
  sha256 "3c0ede893011319f9b0a56b44953a3d52c7abf9657c23fb4bc9ced93b86e9c97"
  license "Python-2.0"

  livecheck do
    formula "python@3.10"
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "3e7b9898dadb5091204da29fe887e305efaa935fc5da021c7cc228c1af2584dc"
    sha256 cellar: :any, arm64_big_sur:  "a05137e7314633683ace197def05eced24b3105c13cad4d0fac3dbab55febb50"
    sha256 cellar: :any, monterey:       "06f73104bbac0f422be8dcce1fede38f7c752a19c5a8017df3b14fa1080e9b90"
    sha256 cellar: :any, big_sur:        "f5ae4e9c624d456dcbfcabf98cd3c88d2d91d0099fd92beb7a33d344d9f5b481"
    sha256 cellar: :any, catalina:       "9f631f54a94f9c0e5d235ecc905d5f075d4ac4fe195dbc838d3a4c4a469917a6"
    sha256               x86_64_linux:   "fd375b386627b5bfa133c01bcf7e4aed422ea1ebbd0d4dfc44d974c4beed406f"
  end

  keg_only :versioned_formula

  depends_on "python@3.10"
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
      system Formula["python@3.10"].bin/"python3", *Language::Python.setup_install_args(libexec),
                                                  "--install-lib=#{libexec}"
      rm_r Dir[libexec/"*.egg-info"]
    end
  end

  test do
    system Formula["python@3.10"].bin/"python3", "-c", "import tkinter"

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system Formula["python@3.10"].bin/"python3", "-c", "import tkinter; root = tkinter.Tk()"
  end
end
