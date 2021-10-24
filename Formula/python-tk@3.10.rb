class PythonTkAT310 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.10.0/Python-3.10.0.tgz"
  sha256 "c4e0cbad57c90690cb813fb4663ef670b4d0f587d8171e2c42bd4c9245bd2758"
  license "Python-2.0"
  revision 1

  livecheck do
    formula "python@3.10"
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "5c5ca802727c9bb7cad99b3335db43efcc0ab3d0b47035884ff804dd764cbad2"
    sha256 cellar: :any, arm64_big_sur:  "6495ba7d17711b36a7cec076db2458da038d4b3adb83b6d70404c7bc39eb5ec8"
    sha256 cellar: :any, monterey:       "1a4ddbb28f7fd41be9864a80234d41d53f49056878fb8fc7a5b5fc6f73682c10"
    sha256 cellar: :any, big_sur:        "9a840114d16d6f0e164e4b7af1b20d95196431bc128473f866fffd69f028eef8"
    sha256 cellar: :any, catalina:       "bd83cb8f690893fb79ec7f4ba8414455bc175f246c764e48ec2991b1a94fb35d"
    sha256 cellar: :any, mojave:         "fde0835103328932bf87517e9737cca4d9bbf0b7b6a17eba99fc7eaa9647c2c8"
    sha256               x86_64_linux:   "2d9582d815f79fa032d38f4db9ba6e2842670f5340dade2238783e3ca821d1bc"
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

    on_linux do
      # tk does not work in headless mode
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    system Formula["python@3.10"].bin/"python3", "-c", "import tkinter; root = tkinter.Tk()"
  end
end
