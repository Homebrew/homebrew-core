class PythonTkAT312 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.12.0/Python-3.12.0.tgz"
  sha256 "51412956d24a1ef7c97f1cb5f70e185c13e3de1f50d131c0aac6338080687afb"
  license "Python-2.0"

  livecheck do
    formula "python@3.12"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c1e3f95ef0bbb7f7b985300063497c6daa4abf5131f93b711663565c4d240af9"
    sha256 cellar: :any,                 arm64_ventura:  "d73fd18d8772759c5db612d25de99c6a9c5bb8d876b967267c72e493cff1c06d"
    sha256 cellar: :any,                 arm64_monterey: "adb4224b81a9e32c9c66f1b055dae2325e8416768d4e96f36a883ba2a3ab16f9"
    sha256 cellar: :any,                 sonoma:         "b3163730c16bf5ede90c961cdb3800a05180f37149c6d9a5d1ce011356bb94be"
    sha256 cellar: :any,                 ventura:        "7da79232776f6e13ec59e23ac61ed74d1115697af7dcd7f6f71e7c2de8b44afb"
    sha256 cellar: :any,                 monterey:       "b6ec1890f7aba762eeb685b1e7cde18ac054b60d96e58aee9e130883238c3b5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20baa46e683be2d9dda96a3b38550eee7290a0514e1bcf97ce9d7b529ee1c70a"
  end

  depends_on "python@3.12"
  depends_on "tcl-tk"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/ef/cc/93f7213b2ab5ed383f98ce8020e632ef256b406b8569606c3f160ed8e1c9/setuptools-68.2.2.tar.gz"
    sha256 "4ac1475276d2f1c48684874089fefcd83bd7162ddaafb81fac866ba0db282a87"
  end

  def python3
    "python3.12"
  end

  def install
    ENV.append_path "PYTHONPATH", buildpath/Language::Python.site_packages(python3)
    resource("setuptools").stage do
      system python3, "-m", "pip", "install", *std_pip_args(prefix: buildpath), "."
    end

    xy = Language::Python.major_minor_version python3
    python_include = if OS.mac?
      Formula["python@#{xy}"].opt_frameworks/"Python.framework/Versions/#{xy}/include/python#{xy}"
    else
      Formula["python@#{xy}"].opt_include/"python#{xy}"
    end

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
                          include_dirs=["#{python_include}/internal", "#{Formula["tcl-tk"].opt_include/"tcl-tk"}"],
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
