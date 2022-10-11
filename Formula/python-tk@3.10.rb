class PythonTkAT310 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.10.8/Python-3.10.8.tgz"
  sha256 "f400c3fb394b8bef1292f6dc1292c5fadc3533039a5bc0c3e885f3e16738029a"
  license "Python-2.0"

  livecheck do
    formula "python@3.10"
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "d159afb5e0ea0b20fa933bf1f5dc03f232b79ea2a2267d74cd52b658b28ad02a"
    sha256 cellar: :any, arm64_big_sur:  "fffd829d742cfffb073e8c2f6e8611cf0f2e5fdd5354d997e650ae7c77d87a7a"
    sha256 cellar: :any, monterey:       "0e1135afbca6709c63f4024d1d38b723ec20d1bc7081ff53d489088e0708a06e"
    sha256 cellar: :any, big_sur:        "645515e9bb9ca4e8ccbcc6625252fe5920f712e7cdb1e0c0b74949bd924aa3e4"
    sha256 cellar: :any, catalina:       "2c46b9e49529ca1ca93b391b75aeb75c621e2d3d2c3117ed7da720d991756c91"
    sha256               x86_64_linux:   "ba9235f803f0aa9711f1b4723b19ecfab2dc7c00df0d4b228fef96b1f8f5b986"
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
