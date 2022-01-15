class PythonTkAT39 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.9.10/Python-3.9.10.tar.xz"
  sha256 "0a8fbfb5287ebc3a13e9baf3d54e08fa06778ffeccf6311aef821bb3a6586cc8"
  license "Python-2.0"

  livecheck do
    formula "python@3.9"
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "f1a19f4e7bc6353fcc3cf445887327871dacbbe911a85a764cc850339e5cbe7a"
    sha256 cellar: :any, arm64_big_sur:  "af848416d1a1e4832432a507804ae1541855f0d9eb74ac9b0a11de71cff46221"
    sha256 cellar: :any, monterey:       "42fa5ccf9e1ab957a84934553e1f7ad775f7a509d254eb04f9e1608b15c430c6"
    sha256 cellar: :any, big_sur:        "9ce5eb27db025494313681ccb3420be48fe3938cca67c04b307f6f40a5588a44"
    sha256 cellar: :any, catalina:       "54e068e0cd5a15bf6602bdd2f776d77c02490ce8bd30522404af1017dc51c395"
    sha256               x86_64_linux:   "02a180b21d8a5fd52f0a39d8657c4376b6da3d878209cc178e82e46e61eee366"
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
