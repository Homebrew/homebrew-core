class PythonTkAT39 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  # Keep in sync with python@3.9.
  url "https://www.python.org/ftp/python/3.9.7/Python-3.9.7.tar.xz"
  sha256 "f8145616e68c00041d1a6399b76387390388f8359581abc24432bb969b5e3c57"
  license "Python-2.0"

  livecheck do
    formula "python@3.9"
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "53a29c3b706b30b0b6f507e348356dbc04140cfefd1f946ea2b1c59f2d09c24a"
    sha256 cellar: :any, big_sur:       "03bc2e4a0a04a0ee27ac4909624c017205d4a92a32a4092a61ea8343e1db8383"
    sha256 cellar: :any, catalina:      "d329945ff20c6fd56dea36e269fdec709a035f0520d44c06d8312c2efe0337be"
    sha256 cellar: :any, mojave:        "4439eda13ad78f68a4ddacef195eb6c797a67c4d1f033fcf5a825e694cddaa0e"
    sha256               x86_64_linux:  "10ad86256ecabd270a8564a4e782270043a9bd1042117c45c11abc8ffb11c750"
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
