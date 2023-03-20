class PythonTkAT310 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.10.10/Python-3.10.10.tgz"
  sha256 "fba64559dde21ebdc953e4565e731573bb61159de8e4d4cedee70fb1196f610d"
  license "Python-2.0"

  livecheck do
    formula "python@3.10"
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "09151dcb365ffbd31c371da3ea52f688f68e5e6e34812ee2de0eeb387c6ff25b"
    sha256 cellar: :any, arm64_monterey: "0af569776354044dcd1c10c9d95690069757cb5ae684572f7d98f536a3b31c20"
    sha256 cellar: :any, arm64_big_sur:  "4e762708d772fd93792122992d83e99c747ec44f051613026a67731074afc6ba"
    sha256 cellar: :any, ventura:        "a7289c54d92181d5c50dc2556bdea1ea4c53679b4abf66bc1191d04369aa5e70"
    sha256 cellar: :any, monterey:       "26e875fa1c76b7be4026f3833a0c37a4ac2fbad889b2ad0474222ca969df79b6"
    sha256 cellar: :any, big_sur:        "90bedbb1a6fe2c28058ef9114cfad91b4ed6a54d2676ee3d243c3c5a3f506682"
    sha256               x86_64_linux:   "30f84721267504f85471728e86b9ccc9020d0361b16b25e45ca1858d30686063"
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
                          include_dirs=["#{Formula["tcl-tk"].opt_include}"],
                          libraries=["tcl#{tcltk_version}", "tk#{tcltk_version}"],
                          library_dirs=["#{Formula["tcl-tk"].opt_lib}"])
              ]
        )
      EOS
      system python3, *Language::Python.setup_install_args(libexec, python3),
                      "--install-lib=#{libexec}"
      rm_r Dir[libexec/"*.egg-info"]
    end
  end

  test do
    system python3, "-c", "import tkinter"

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system python3, "-c", "import tkinter; root = tkinter.Tk()"
  end
end
