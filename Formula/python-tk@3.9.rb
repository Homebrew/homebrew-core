class PythonTkAT39 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  # Keep in sync with python@3.9.
  url "https://www.python.org/ftp/python/3.9.2/Python-3.9.2.tar.xz"
  sha256 "3c2034c54f811448f516668dce09d24008a0716c3a794dd8639b5388cbde247d"
  license "Python-2.0"

  livecheck do
    url "https://www.python.org/ftp/python/"
    regex(%r{href=.*?v?(3\.9(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4a771a6755d5ad722678c41dde219f9d62df4d3c8d2f05c6002461736c2abed0"
    sha256 cellar: :any, big_sur:       "45884c6e1b7f452fc0c3c89d89e2de6639824f140c67c53e353f69887ea6378f"
    sha256 cellar: :any, catalina:      "e5e3c6c10cdcc2d54198c740cf10c622fc2cf3059f4f02218654f6eea6ede596"
    sha256 cellar: :any, mojave:        "176a6e77537361a28a0d65d4abbb02bad406dc1f6bd8d49c3fad58a4ab433093"
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
      system Formula["python@3.9"].bin/"python3", *Language::Python.setup_install_args(prefix)
      rm_r Dir[lib/"python3.9/site-packages/*.egg-info"]
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
