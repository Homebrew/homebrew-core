class PythonTkAT39 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.9.19/Python-3.9.19.tar.xz"
  sha256 "d4892cd1618f6458cb851208c030df1482779609d0f3939991bd38184f8c679e"
  license "Python-2.0"

  livecheck do
    formula "python@3.9"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7f6272ad30e48e306397b068f2064a36d405e795d4805aae4c925f1073a385dc"
    sha256 cellar: :any,                 arm64_ventura:  "8efc8964d31d301ae4e9382e0903f40061ec6a832da0def5fc9c4820d2045f82"
    sha256 cellar: :any,                 arm64_monterey: "a67ae974fc6d23bffd2bb902df0f848ae47569ff367dadaca3fd435a08147323"
    sha256 cellar: :any,                 sonoma:         "e06800ab45ed107d7a5ef009d53af144ead2da982802bd346442ff56eb4c5ea5"
    sha256 cellar: :any,                 ventura:        "6385f4fee0e4035239afa1057a563ef94127a4424fcbb32aaec5777b2cfb0dec"
    sha256 cellar: :any,                 monterey:       "4c7b09a65e0a6445a3f582f81de8088e0a8bc0dca50dbf10f554c08f01ee95e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a98bba397c793b56ace409f02712fe57c8e60840ffbce3fa3e4037090c57133"
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
