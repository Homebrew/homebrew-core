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
    sha256 cellar: :any, arm64_monterey: "17cacd2c17335c4f1339a52dba6bf34a05c0b907e7fdbf3e5ba5c12653ae4a69"
    sha256 cellar: :any, arm64_big_sur:  "8bd65f755163bddb704b663bedd678ed1b96e20ee52c869ae87a1d2e25879926"
    sha256 cellar: :any, monterey:       "e4fa0a7945b0ce190468ab396a81e53282b865ee31552e1296bc5fded7f6f237"
    sha256 cellar: :any, big_sur:        "ce608e55dd668b4b962f848b615a89d9bfd14ac178f85a231d710428d8183b3c"
    sha256 cellar: :any, catalina:       "3efc70ba2ebccdbd611bed0f8c4d6e836b1cdd1801e1a9a8995cd4f4f544c29c"
    sha256               x86_64_linux:   "d6da0aab4b89fd738b412609ed09a28c6c253fb848a1b86b02a4ce48c7a2ca21"
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
