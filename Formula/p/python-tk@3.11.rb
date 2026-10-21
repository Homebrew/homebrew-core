class PythonTkAT311 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.17/Python-3.11.17.tgz"
  sha256 "53cdee63ac4bf12387b7b33a53d3b1f8f4941cad73807a7b4fe91bb001ef004a"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "72890c619c3f7831ebb30fb619523b1b8096b296e18891e2dd9f09130795cb5d"
    sha256 cellar: :any, arm64_tahoe:       "24459641d8caf7542ba26e9e49a35b034450b0923def0ed2603cdda80a55fc68"
    sha256 cellar: :any, arm64_sequoia:     "466331c85c87a058e37c02dd694acd4cdc4bbe3db33b9542038c8f27ad3de082"
    sha256 cellar: :any, arm64_linux:       "8d8f4accd32a955c1ea58cf51dec63a3d449eedf6acbe6d283f324d045f248c4"
    sha256 cellar: :any, x86_64_linux:      "6b80fa3ad951164bc74ef5d23c00da343669f6108ba53c063750d555de5e3ffd"
  end

  # https://devguide.python.org/versions/#versions
  # https://sourceforge.net/p/tcl/mailman/message/59333692/
  deprecate! date: "2026-10-04", because: "needs EOL Tcl/Tk 8.6"
  disable! date: "2028-01-01", because: :deprecated_upstream

  depends_on "python@3.11"
  depends_on "tcl-tk@8"

  def install
    cd "Modules" do
      tcltk = Formula["tcl-tk@8"]
      tcltk_version = tcltk.any_installed_version.major_minor
      Pathname("setup.py").write <<~PYTHON
        from setuptools import setup, Extension

        setup(name="tkinter",
              description="#{desc}",
              version="#{version}",
              ext_modules = [
                Extension("_tkinter", ["_tkinter.c", "tkappinit.c"],
                          define_macros=[("WITH_APPINIT", 1)],
                          include_dirs=["#{tcltk.opt_include/"tcl-tk"}"],
                          libraries=["tcl#{tcltk_version}", "tk#{tcltk_version}"],
                          library_dirs=["#{tcltk.opt_lib}"])
              ]
        )
      PYTHON
      system python3, "-m", "pip", "install", *std_pip_args(prefix: false), "--target=#{libexec}", "."
      rm_r libexec.glob("*.dist-info")
    end
  end

  test do
    system python3, "-c", "import tkinter"
  end
end
