class PythonTkAT39 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.9.15/Python-3.9.15.tar.xz"
  sha256 "12daff6809528d9f6154216950423c9e30f0e47336cb57c6aa0b4387dd5eb4b2"
  license "Python-2.0"

  livecheck do
    formula "python@3.9"
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "a6eced87cfe5d3bb323097e0a480236228d61f0de2fae6424d53caa9e48f3c54"
    sha256 cellar: :any, arm64_big_sur:  "4ce7bf5f329ef0a70474fbe3a85752d5cd25643979ac201adac2a019e956bb1c"
    sha256 cellar: :any, monterey:       "b3f04293a527b321ff94e8aea016a823d82a9705dcdb9c83dd9c8164d9bac15c"
    sha256 cellar: :any, big_sur:        "728936ed07d80d81f3911766e1889ee8d1dd5aa0484dd4350aa1281c35522a2b"
    sha256 cellar: :any, catalina:       "1581abd989cc61ccf0659d328826ab9f5c3fb7d422292ddb2a921c3880902a1c"
    sha256               x86_64_linux:   "c1256936bd66c9ee6b37af5d906e6c42b2361b7682c01e8cc1a796de3d6bc775"
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
      system "python3.9", *Language::Python.setup_install_args(libexec), "--install-lib=#{libexec}"
      rm_r libexec.glob("*.egg-info")
    end
  end

  test do
    system "python3.9", "-c", "import tkinter"

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "python3.9", "-c", "import tkinter; root = tkinter.Tk()"
  end
end
