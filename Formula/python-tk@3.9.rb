class PythonTkAT39 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  # Keep in sync with python@3.9.
  url "https://www.python.org/ftp/python/3.9.4/Python-3.9.4.tar.xz"
  sha256 "4b0e6644a76f8df864ae24ac500a51bbf68bd098f6a173e27d3b61cdca9aa134"
  license "Python-2.0"

  livecheck do
    url "https://www.python.org/ftp/python/"
    regex(%r{href=.*?v?(3\.9(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "377cd05c77225a22344719c94ebae986dcc794af9ead40d6be89501a5b816ef2"
    sha256 cellar: :any, big_sur:       "b5505e8ee5a218e0258454892ed9d8230f1022b32af50184529d762120fd6b63"
    sha256 cellar: :any, catalina:      "8413b1a6f7bcfcf07434925c4e5896145c2e2a1600e4b7fa1ea66c24073c84a3"
    sha256 cellar: :any, mojave:        "24dbeb5ff963ee45302047d6fa05456b44349dd7662c633cdca240a1abc7ac3e"
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
