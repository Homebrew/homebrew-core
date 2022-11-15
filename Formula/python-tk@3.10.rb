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
    sha256 cellar: :any, arm64_ventura:  "08c243168db901bed54f2596034c578283eefd8a9744eca346f4fbe1dca8d799"
    sha256 cellar: :any, arm64_monterey: "b28fa88f88581f432a9c17c5dcc065e81b16d7eaf739ed702e9de511ebbef048"
    sha256 cellar: :any, arm64_big_sur:  "b9633cfa0899bdad1bb0568ca8f8731ba124c2a7f00f4970558fa124280e5d2b"
    sha256 cellar: :any, ventura:        "81c3360cf1d2fc74a7809af4d9deaccfb9d0a3b653826204c866945f7235f8b5"
    sha256 cellar: :any, monterey:       "367b3dfc45ac1c33655181e9fdd28bd0984c6fafad3edf7538ec2b5d611ddf95"
    sha256 cellar: :any, big_sur:        "d0f6ee0c2b06cb096c59868b1c8116fae96d3aa3a7ab8e89d6e2b9f160b217ff"
    sha256 cellar: :any, catalina:       "62469dbf3c34554e9ca8bf21b91ed6efa2af595d7f06990476dbe97552b3ab23"
    sha256               x86_64_linux:   "378de196b95470e825f1df2691c4fa9f04f429bc277a4f629038d93f8d3eec72"
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
