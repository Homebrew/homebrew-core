class PythonTkAT39 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.9.24/Python-3.9.24.tar.xz"
  sha256 "668391afabd5083faafa4543753d190f82f33ce6ba22d6e9ac728b43644b278a"
  license "Python-2.0"

  livecheck do
    formula "python@3.9"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "787a3760917a3f6ac64e8294c42a5ffbc997a19b7b8ab78c2d798b5e4a8bcce9"
    sha256 cellar: :any,                 arm64_sequoia: "6132ef0a8f4712fe8d4f1a5524d72d4a826e64df8a357c9976a544dcfd256dde"
    sha256 cellar: :any,                 arm64_sonoma:  "9bc5ce6643d44c6a5cfbf00dbfc09e490e4061fdd0a2a27e87a21870e710cca5"
    sha256 cellar: :any,                 sonoma:        "68a3ee0b1fb5bb1199b050231c7e5f4873d83854c9285f4ff02a01536d3a6595"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "584c2f7e4a9a4e6723ab14659c4fdfd40913e2394b8e744af2bbe180cb868e2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75d144c971b8266750f99b1afbe9cb486d45be5d141f9ab15c9ce5af35e0bb13"
  end

  # Follow up to python@3.9 deprecation
  deprecate! date: "2025-10-15", because: :deprecated_upstream
  disable! date: "2026-10-15", because: :deprecated_upstream

  depends_on "python@3.9"
  depends_on "tcl-tk@8"

  def python3
    "python3.9"
  end

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

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system python3, "-c", "import tkinter; root = tkinter.Tk()"
  end
end
