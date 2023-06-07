class PythonTkAT310 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.10.12/Python-3.10.12.tgz"
  sha256 "a43cd383f3999a6f4a7db2062b2fc9594fefa73e175b3aedafa295a51a7bb65c"
  license "Python-2.0"

  livecheck do
    formula "python@3.10"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "12050efc6d9c9298b23bb976fd4a266b45dc0a9f4681d99d79d869cceb1e0a15"
    sha256 cellar: :any,                 arm64_monterey: "f62bdd3499ded4bc014b7bd9af3d29a49047b9c2c7664b7d81963e768ec2adaa"
    sha256 cellar: :any,                 arm64_big_sur:  "d92880cd78e20c2510f02de489bc5ee517b76b0eab4b80c0108505dac28b85da"
    sha256 cellar: :any,                 ventura:        "4cb74f1480de294572abbab0a5ad00c27cc057019b56bdc5427f0eab313be888"
    sha256 cellar: :any,                 monterey:       "4862c3bfc2cc2feea37ef36d3bbdda58f6135e590bf12c5f369f120746d96d02"
    sha256 cellar: :any,                 big_sur:        "8e3168c438ef62039ff2f2aa69a76e74f46fb0ee9477bcf5e9ec50565f2656a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ce8a2177780709a364a5fb1ab9b0c71d648e1e407a73230f874fd3a1c2f8f6d"
  end

  keg_only :versioned_formula

  depends_on "python@3.10"
  depends_on "tcl-tk"

  def python3
    "python3.10"
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
                          include_dirs=["#{Formula["tcl-tk"].opt_include/"tcl-tk"}"],
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
