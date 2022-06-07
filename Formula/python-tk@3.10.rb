class PythonTkAT310 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.10.5/Python-3.10.5.tgz"
  sha256 "18f57182a2de3b0be76dfc39fdcfd28156bb6dd23e5f08696f7492e9e3d0bf2d"
  license "Python-2.0"

  livecheck do
    formula "python@3.10"
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "7740ddbd35352e3f2336103b502a7f4e81f2974291504076a4515893435ccfb2"
    sha256 cellar: :any, arm64_big_sur:  "4b6e6da3a3c725bde9be6a4d4a0922acda7bf1fbeb997a053cc91b768aae871d"
    sha256 cellar: :any, monterey:       "6a937be1fd531589ef7f9b4d971cb91ee7549d99f7f1aaf97f0fc3c0911f1c5d"
    sha256 cellar: :any, big_sur:        "c08f7d32f905c34c37f94bba1b64071f373fde8a81866c890d1ed48e6f25531e"
    sha256 cellar: :any, catalina:       "4fb512fc0154201d044baf8cf1c929bef99c11b7f4f3b4d81de7903aadfaf110"
    sha256               x86_64_linux:   "c256a3e8e2bd186387dca4763c6f7d7373052a63217ef2d01a63614847084b0a"
  end

  keg_only :versioned_formula

  depends_on "python@3.10"
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
      system Formula["python@3.10"].bin/"python3", *Language::Python.setup_install_args(libexec),
                                                  "--install-lib=#{libexec}"
      rm_r Dir[libexec/"*.egg-info"]
    end
  end

  test do
    system Formula["python@3.10"].bin/"python3", "-c", "import tkinter"

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system Formula["python@3.10"].bin/"python3", "-c", "import tkinter; root = tkinter.Tk()"
  end
end
