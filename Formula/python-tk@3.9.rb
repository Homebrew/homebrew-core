class PythonTkAT39 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.9.12/Python-3.9.12.tar.xz"
  sha256 "2cd94b20670e4159c6d9ab57f91dbf255b97d8c1a1451d1c35f4ec1968adf971"
  license "Python-2.0"

  livecheck do
    formula "python@3.9"
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "8ae915fb7663ba76bd00c789edc92fdfa345ac434f5ba0d4b4483dc62546e36a"
    sha256 cellar: :any, arm64_big_sur:  "b129c352522e722576d8898c318a37270ab60d28719c0531bded1654b2d102fd"
    sha256 cellar: :any, monterey:       "8462f2d73c41ca45b3d3a71a18df3b4fdbc28b7e30aa42a7a301294aa7e891d4"
    sha256 cellar: :any, big_sur:        "7b7007579479517207b350d3d0d7cbb760f5a5ff3653835d25ff4b37a6d72103"
    sha256 cellar: :any, catalina:       "7d7bba1315d52c0154950c87e49ba24ee2d908f7a2e3ae8e0cafa54384df5dfa"
    sha256               x86_64_linux:   "077307456eff2583df509b04bbea3cf8d62b60d9378e3eff5db91d8681ddb8b7"
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
