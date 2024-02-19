class PythonTkAT312 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.12.2/Python-3.12.2.tgz"
  sha256 "a7c4f6a9dc423d8c328003254ab0c9338b83037bd787d680826a5bf84308116e"
  license "Python-2.0"

  livecheck do
    formula "python@3.12"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3f8cdfdeca32f72686019986c09f521cd428ebe01c75ae4fbe839ddc681f3654"
    sha256 cellar: :any,                 arm64_ventura:  "488d7b0dec20900fa6aec0446e22c5dc1601a335c8f0f3463a197570f1e54590"
    sha256 cellar: :any,                 arm64_monterey: "4a33a5fd920fa919c2581263585af27dd042f9df54426d7b71683723f074e29e"
    sha256 cellar: :any,                 sonoma:         "ed364494042a81636397d0c625471d42e2611892fe38df152f4e67898ef5b169"
    sha256 cellar: :any,                 ventura:        "df78a1afae464265bcdd1bc11435cf822a5f52812490e8390481f56cc9fd3878"
    sha256 cellar: :any,                 monterey:       "bdb69741aa19e6d62f3bab9ce62e7ebaded9d458df33b84564004b60ff2f70c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab97031948f1e9fdc8f04f0d2d794cb67615303631e40c79a34ae04740732b01"
  end

  depends_on "python@3.12"
  depends_on "tcl-tk"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4b/d9/d0cf66484b7e28a9c42db7e3929caed46f8b80478cd8c9bd38b7be059150/setuptools-69.0.2.tar.gz"
    sha256 "735896e78a4742605974de002ac60562d286fa8051a7e2299445e8e8fbb01aa6"
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
