class PythonTkAT311 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.10/Python-3.11.10.tgz"
  sha256 "92f2faf242681bfa406d53a51e17d42c5373affe23a130cd9697e132ef574706"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "bd4c45eefc752d5eaf5c4cdf7743f01e1246fee55877e799ec5084e19da0358e"
    sha256 cellar: :any,                 arm64_sonoma:   "9287934719a90c587a8f9f5f1ce573b981c04ff4157b34659bd31d9e2ef20a54"
    sha256 cellar: :any,                 arm64_ventura:  "2c19ff182ef75d024aded65fd95c0d9f670d849577297cb882d98b0b2851fa6a"
    sha256 cellar: :any,                 arm64_monterey: "4bb989fa2b025dbf2d8a3a582ffca9ee8fc5b18dff05a73af5d26832f2f54b62"
    sha256 cellar: :any,                 sonoma:         "168e04abd04bee52b6466e5f56eeaf4bd7565b5a20008d2d698f46b4340d0b10"
    sha256 cellar: :any,                 ventura:        "2fba5988208e5ac77365e46ce4be73e8ffe43fdf1279c221a6688fd8d4f036e4"
    sha256 cellar: :any,                 monterey:       "6ccfb528437d9888e01be38a7108c93ed35e6b08a5fd88d313a5a23857abde65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b20e3064ca7d36a64c665962d4e866d9f8bdb3e611617fcd6bdd7d5043c43b81"
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
