class PythonTkAT311 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.2/Python-3.11.2.tgz"
  sha256 "2411c74bda5bbcfcddaf4531f66d1adc73f247f529aee981b029513aefdbf849"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "8e8d4bd266814f717bde8f2e7cfc64c19a73eddbcf135868b92b3117af2599bf"
    sha256 cellar: :any, arm64_monterey: "dce1b451967b4337e0cb9fea0513ce528d072cd31f5f38806550024ada55cf32"
    sha256 cellar: :any, arm64_big_sur:  "2974f8a647a7957de43a5ceb86024167d11e200668b18d0ab17a724f5b2c48df"
    sha256 cellar: :any, ventura:        "8701efd4ba1e9dd83fdf2c520bf9a69ed3092c0628d4883a0a803d47e04461e8"
    sha256 cellar: :any, monterey:       "097debb6fca9943662df0250fb32b95f09822301a26ba7ce1a5a4fc9f7d0997d"
    sha256 cellar: :any, big_sur:        "b1a55cfd57204ce771e965b211e2760e44d12f53d5d4c4ac4c08d3ac1e57dbd3"
    sha256               x86_64_linux:   "1f47eccff0b08412d65103b71a75e6a6bff73cf0a60575fbe570ec67d71f9457"
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
