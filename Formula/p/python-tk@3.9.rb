class PythonTkAT39 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.9.17/Python-3.9.17.tar.xz"
  sha256 "30ce057c44f283f8ed93606ccbdb8d51dd526bdc4c62cce5e0dc217bfa3e8cee"
  license "Python-2.0"

  livecheck do
    formula "python@3.9"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f369c18321c9dc521fb5543216c2d849fdeaaf810919609ef2124b48389c9861"
    sha256 cellar: :any,                 arm64_monterey: "71592e3824ad19a9b5e77ff64dd89b0b2b0fa801fe8621515c9b6781a307261d"
    sha256 cellar: :any,                 arm64_big_sur:  "45d696bf3513939622057140a8f229c962d7bc3d9c834be8f15bc27c8aa4ffce"
    sha256 cellar: :any,                 ventura:        "643a4457e7f4f9d5c4204024529e407812776b6d95e6d6211bf04935993a647d"
    sha256 cellar: :any,                 monterey:       "fe873782c67bff21a31d06e5fef74f0714d7d0e6167626b1f9f3e18b8a7cf54f"
    sha256 cellar: :any,                 big_sur:        "a938d2af1c9b3debd81ec9562b67ef1fdb8054f1ae5cee5c39cea7dfa3e2095e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a480f9c189662ac6c023f4f8fb3a463866e2fb253671a3a64364379a3993ec93"
  end

  depends_on "python@3.9"
  depends_on "tcl-tk"

  def python3
    "python3.9"
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
      system python3, *Language::Python.setup_install_args(libexec), "--install-lib=#{libexec}"
      rm_r libexec.glob("*.egg-info")
    end
  end

  test do
    system python3, "-c", "import tkinter"

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system python3, "-c", "import tkinter; root = tkinter.Tk()"
  end
end
