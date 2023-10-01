class PythonTkAT311 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.5/Python-3.11.5.tgz"
  sha256 "a12a0a013a30b846c786c010f2c19dd36b7298d888f7c4bd1581d90ce18b5e58"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cf2678141a9760066b5742ca75f967c61c408fb684ea3957fe14b7f4f82a7a59"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5844fa8f52d14b4beda66b05aa35659a0894d0191e6b8b39cc8bb58dce688f33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf0e26a34872554aa0323b61d0ec5b2aa71cfd291c2b93ddb2a7a92419717610"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47c3b5e525baec45b02848b400e26a67022ae3c52304fbcab8c38d3eb942ef83"
    sha256 cellar: :any,                 sonoma:         "61705b7a429e94be6f46a8be92f7f91e8102791c7156c9bd50c1913d195a8a62"
    sha256 cellar: :any_skip_relocation, ventura:        "40b26d0ef0df727124c374ef8552aea27d0a9e5e45fc72c5d02fec2e43dfa1d4"
    sha256 cellar: :any_skip_relocation, monterey:       "aee33ea9893d1765e0e4606fa28117097855982bba4d3016dea1fbeeecf5071a"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfa211f6ceae8b0a059238de543a5142bc7bc147e1b4b21e8f9e24386753dc8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dc525befaa4d2172771916e3770c08a2b8d04026c5797bc2a27b67d7c37ef87"
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
