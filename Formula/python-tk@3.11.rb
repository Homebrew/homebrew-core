class PythonTkAT311 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.0/Python-3.11.0.tgz"
  sha256 "64424e96e2457abbac899b90f9530985b51eef2905951febd935f0e73414caeb"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "609fa4a576dd6fe98513545fa63026ea2e441bc93c5c9c7ffbd0038254465b56"
    sha256 cellar: :any, arm64_monterey: "8c238e600565e35bc43eaa2031d5a65b254c2312bcafa1e1e45551bfd1039093"
    sha256 cellar: :any, arm64_big_sur:  "5980d76b9d77e5307c0a1c5638f237df590d5e8dae8499da4e73a85661ca1cba"
    sha256 cellar: :any, ventura:        "8ae9fefeeaad3f5822911005c0cbd9e3574177a3880da36449c2d66857e324c3"
    sha256 cellar: :any, monterey:       "c70b3353802b12baa1a9ab4797992a8560794e3a4324879091c99924a18f4cfa"
    sha256 cellar: :any, big_sur:        "35fe499d862b7dd3884baa2cf7ab6c9ca5dfbca5b1fb707036ba16f8c4dc7072"
    sha256 cellar: :any, catalina:       "4238e0b6ae7043908cfec513cbb8346e7e9a4435dac2c06b1bb67d6a9934a579"
    sha256               x86_64_linux:   "d054fd0c4fcadbeccba138390da24c06dc87f00e46e9d646097abd2f95cf61ac"
  end

  depends_on "python@3.11"
  depends_on "tcl-tk"

  def python3
    "python3.11"
  end

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
      system python3, *Language::Python.setup_install_args(libexec, python3),
                      "--install-lib=#{libexec}"
      rm_r libexec.glob("*.egg-info")
    end
  end

  test do
    system python3, "-c", "import tkinter"

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system python3, "-c", "import tkinter; root = tkinter.Tk()"
  end
end
