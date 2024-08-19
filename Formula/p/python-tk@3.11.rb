class PythonTkAT311 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.9/Python-3.11.9.tgz"
  sha256 "e7de3240a8bc2b1e1ba5c81bf943f06861ff494b69fda990ce2722a504c6153d"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a97daae430ce92e008507aeea26326899dbcec2b732feedcf0d054750d7c7da2"
    sha256 cellar: :any,                 arm64_ventura:  "f550ab7bdfc48af2d4a9d24ee73fe526f70a99357755e106e60250226ced321a"
    sha256 cellar: :any,                 arm64_monterey: "4e8067d9ea6cf95d4b9c86e08db7f48d5fd8ab234044f10759ce35909d4e000a"
    sha256 cellar: :any,                 sonoma:         "bde96b552e6eb9f0c50df11b3d181b09de540836172e064da10f07f429f9850c"
    sha256 cellar: :any,                 ventura:        "6d50d0264702e67bb3d042a86063e40ac817e74786505a0fbb1c0869c8423c67"
    sha256 cellar: :any,                 monterey:       "386d70c7ac89869eac8ab9f90613bdadc26fb20a61085004429793673b29bdea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "580aba216166341642a3e7e3f42501719ffbb237d104d42fae27069fbb44598d"
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
      system python3, "-m", "pip", "install", *std_pip_args(prefix: false), "--target=#{libexec}", "."
      rm_r libexec.glob("*.dist-info")
    end
  end

  test do
    system python3, "-c", "import tkinter"

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system python3, "-c", "import tkinter; root = tkinter.Tk()"
  end
end
