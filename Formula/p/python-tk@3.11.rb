class PythonTkAT311 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.8/Python-3.11.8.tgz"
  sha256 "d3019a613b9e8761d260d9ebe3bd4df63976de30464e5c0189566e1ae3f61889"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "735195ebd55e1cc7ac98f3306fece7337b83d018eae99efebe890fcc8b9fb8ad"
    sha256 cellar: :any,                 arm64_ventura:  "f44cbbd4c0e8bebefc50e75d300ffc2e9ba7d4eea45ff98f8e926e5fd401be00"
    sha256 cellar: :any,                 arm64_monterey: "fbcb392587884d4192e3c6d09a5e5164e612fb05e4b9f631b214ecd13351720b"
    sha256 cellar: :any,                 sonoma:         "cb53364018105f70f45e66d0a1862107830031a1b42ad4edd73c8a44da6973de"
    sha256 cellar: :any,                 ventura:        "bbe9aa43f2efa38b43d754293f4765e468a179ed5d7517245afc87f5fb2ec8a2"
    sha256 cellar: :any,                 monterey:       "f23e1c5608ca782069523e5e8d0da0fc47b803d3ef4a0333e4e2ed9a466e8c1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5a56f1ce491e7f458da9f38019d4d16a1100cf41b8a7770ceddc3f5a2eba600"
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
