class PythonTkAT310 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.10.11/Python-3.10.11.tgz"
  sha256 "f3db31b668efa983508bd67b5712898aa4247899a346f2eb745734699ccd3859"
  license "Python-2.0"

  livecheck do
    formula "python@3.10"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9a0a8ec94e95c50e6342759ad8131e05cfaafcc58375bfce7004b0ee00a4ebb0"
    sha256 cellar: :any,                 arm64_monterey: "ee5f6b97d7c9744c883c6301c7a378b0fff3d626eb8ff4557b802844f30479a1"
    sha256 cellar: :any,                 arm64_big_sur:  "52446c28e01104e2579b9eb02b68de842189de48dd15afc522eaf79dd6ce1eb0"
    sha256 cellar: :any,                 ventura:        "fbfa94200e5faae888a080afa58578aba1c169e97c842651193fbcd46d86face"
    sha256 cellar: :any,                 monterey:       "83ff7db648a67c4c99990452ad04eacea7219ec009f0a3f0231ba79389932b00"
    sha256 cellar: :any,                 big_sur:        "301ea15e7625db0144fed03dacc59c16c1ce2ecac39fa473aec2e6416c04978c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec79ec9ac475f29de278876dd600ae4738a38797529a9bcb771a820191deb32c"
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
