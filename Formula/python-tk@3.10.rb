class PythonTkAT310 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.10.7/Python-3.10.7.tgz"
  sha256 "1b2e4e2df697c52d36731666979e648beeda5941d0f95740aafbf4163e5cc126"
  license "Python-2.0"

  livecheck do
    formula "python@3.10"
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "979c43ff9c7c60b5cbfd9cd2627a1f946300a6d49a2d80824635b711790a999e"
    sha256 cellar: :any, arm64_big_sur:  "805badbd996b38578881e534a496e96375af6b7061d68174118c9a9cec723c15"
    sha256 cellar: :any, monterey:       "0cf1d9bb358c244a58948e5e2c462379c0cfcaee0ea406f44d1269c469b0e725"
    sha256 cellar: :any, big_sur:        "1a2d5cd59b4824caaac421614d8a73e6348f9219bfe86fcb4cb1ca0f6fc82830"
    sha256 cellar: :any, catalina:       "c26191c478b1ae9a53263f46f298d81fc987af82e54b57c18d1c233fe213a278"
    sha256               x86_64_linux:   "bdad24445f50dfb2a35af261594b476a202081d8adde64cb4b42de802ff15baf"
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
