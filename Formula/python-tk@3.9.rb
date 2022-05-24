class PythonTkAT39 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.9.13/Python-3.9.13.tar.xz"
  sha256 "125b0c598f1e15d2aa65406e83f792df7d171cdf38c16803b149994316a3080f"
  license "Python-2.0"

  livecheck do
    formula "python@3.9"
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "c8db074cc234c9e741340bed4f4778acc53d95ec29e41fa44628b05fbbbada1c"
    sha256 cellar: :any, arm64_big_sur:  "f3092fdad2f1b38cbe9bcb2e6e7006a97a87dae28093170d7118a97bddb62ec1"
    sha256 cellar: :any, monterey:       "44e117a901b6ac21405548aaee24b0cc5b9ded59ca73ffa33a631525348c6611"
    sha256 cellar: :any, big_sur:        "09b0363a026fe863ca904dbee095505aa55ba302ff8764c5c49938ff6c15467c"
    sha256 cellar: :any, catalina:       "4f3561d8c98d1536b6854273db9b666d0101dc889c18a021460fc20c536b3568"
    sha256               x86_64_linux:   "3901b096d0d66fcd4655544b38bdb446bd1b285ff839a118204af51454f7799b"
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
      system Formula["python@3.9"].bin/"python3", *Language::Python.setup_install_args(libexec),
                                                  "--install-lib=#{libexec}"
      rm_r Dir[libexec/"*.egg-info"]
    end
  end

  test do
    system Formula["python@3.9"].bin/"python3", "-c", "import tkinter"

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system Formula["python@3.9"].bin/"python3", "-c", "import tkinter; root = tkinter.Tk()"
  end
end
