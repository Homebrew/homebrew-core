class PythonTkAT311 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.7/Python-3.11.7.tgz"
  sha256 "068c05f82262e57641bd93458dfa883128858f5f4997aad7a36fd25b13b29209"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "025f53bf66ebad184233dbd6c136a033e015893d07f292ca47072ae2af3d2c5d"
    sha256 cellar: :any,                 arm64_ventura:  "e2e532d784cf0bddf48658c6491f61301d7f2d168df464062317b0dc11216c30"
    sha256 cellar: :any,                 arm64_monterey: "79a9e470b618ac34bf98e747d6e769b2bda25b146cb2de01ca3fe449b03363c6"
    sha256 cellar: :any,                 sonoma:         "67eecc1fcb3340aa41d132b6c0efe6700ba68f6e7307cde4b8b3d9a0a104688d"
    sha256 cellar: :any,                 ventura:        "20227b9a0ba0e61ed499fe193f1ae0755f3267d9a8f02b8dce1dc6fe5d44958c"
    sha256 cellar: :any,                 monterey:       "ed8050ce4e92bc2ef0734a1040019e47a3a87d2ab84afb2c68745b3d65cbe8ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ee18c235f45cce29b35dd17ce87cb6a6d0ce9e6d75582499fc1a7ab9744e3ae"
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
