class PythonTkAT39 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.9.16/Python-3.9.16.tar.xz"
  sha256 "22dddc099246dd2760665561e8adb7394ea0cc43a72684c6480f9380f7786439"
  license "Python-2.0"

  livecheck do
    formula "python@3.9"
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "934359e681de64f7c6bea6e951918febb31a521f6b9c28275f8deff484340da3"
    sha256 cellar: :any, arm64_monterey: "78dbca71e130764ff20006aba90d35688e0007af7593dd17a0a68024fb5f0319"
    sha256 cellar: :any, arm64_big_sur:  "38a6238339e1f987a11cf043ddb67c5c74bf264addcf8d647ba7fb8a989e9e68"
    sha256 cellar: :any, ventura:        "232df696df869d89550c0b3142b718f1743768dce53c84774ed617ec0414c59c"
    sha256 cellar: :any, monterey:       "10662af4c3405423b6fa656033fa69b9b49804a9536583989614dbd21ce647db"
    sha256 cellar: :any, big_sur:        "219b1ba1812894e681a9645b38977cec7821c3c752a12ad551ef236cb7d1b4a9"
    sha256               x86_64_linux:   "d8a80d6de08597d9a4613e9ccf0f2921f1525de8496fcf1d07007e85d8ebcb28"
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
