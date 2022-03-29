class PythonTkAT39 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.9.12/Python-3.9.12.tar.xz"
  sha256 "2cd94b20670e4159c6d9ab57f91dbf255b97d8c1a1451d1c35f4ec1968adf971"
  license "Python-2.0"

  livecheck do
    formula "python@3.9"
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "f2a521b5ec62ef1e7e1c511b273fb1dc986c806c09195a01aea886c230ea3319"
    sha256 cellar: :any, arm64_big_sur:  "efa108beb40cb7c780e43fe187a07122eb861d585311e211f873db4b7a006638"
    sha256 cellar: :any, monterey:       "2437b01a2b1e4e70bffd7464bf7a5f4bb234114251fd873c804e3bdcd951f182"
    sha256 cellar: :any, big_sur:        "4c615a7866b9b48d9b44e7758dae8139fa15795bbad1488f75a5bfffd013d10b"
    sha256 cellar: :any, catalina:       "c3b5a2085a4cfe74bef1cd9facf0a6c5611eba927be9ba3161f7e10648a00420"
    sha256               x86_64_linux:   "f905431bf679bce1ead237d759461c2350b2cb01231e374d3d0d0d025741e10b"
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
