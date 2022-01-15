class PythonTkAT310 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.10.2/Python-3.10.2.tgz"
  sha256 "3c0ede893011319f9b0a56b44953a3d52c7abf9657c23fb4bc9ced93b86e9c97"
  license "Python-2.0"

  livecheck do
    formula "python@3.10"
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "d99ef92070c502ae76f845ebc97520765a767ad8f52e14f493cede3ce42547d9"
    sha256 cellar: :any, arm64_big_sur:  "425bb4a1b7d447a31d2038fde63fd77b307c7bdc6fd6caa8533788e886417108"
    sha256 cellar: :any, monterey:       "2edf180c114bbc52e35ce5c0573707c9eccf45eaa1c7b52cb6e2959a51250185"
    sha256 cellar: :any, big_sur:        "ff8728654474d55a0f0cd897f601d653c3a4b9ca36b6221156f7d8e275d5f464"
    sha256 cellar: :any, catalina:       "ce97b04828774e1d91c59d6cc7b5f76ef45f8ac95fddc49ddb68c0be2109cf75"
    sha256               x86_64_linux:   "79bd6d7f0825e6fd1617bbc3bc89249294b6a6a1424d78ec33ad31821af7699c"
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

    on_linux do
      # tk does not work in headless mode
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    system Formula["python@3.10"].bin/"python3", "-c", "import tkinter; root = tkinter.Tk()"
  end
end
