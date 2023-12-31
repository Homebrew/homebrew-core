class PythonTkAT312 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.12.1/Python-3.12.1.tgz"
  sha256 "d01ec6a33bc10009b09c17da95cc2759af5a580a7316b3a446eb4190e13f97b2"
  license "Python-2.0"

  livecheck do
    formula "python@3.12"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b7649965c1117ee20aec659a0815c754ae378638d3212d0d8d7316ec644ad1c4"
    sha256 cellar: :any,                 arm64_ventura:  "40f3ed35492a6469afb1003ea7ae5702a5eac82ae1ff93abb9273f27271ee604"
    sha256 cellar: :any,                 arm64_monterey: "51bda5440029467e721ec433a6cb67d8cd3576c5c1b11620d0966dafe2835609"
    sha256 cellar: :any,                 sonoma:         "9e97917f330be25c18f3551cdc01191ecb9aa8ae9d22a8fbfbda42c0ae6d65d8"
    sha256 cellar: :any,                 ventura:        "bdefc6cfb7a93d0491447b9e64486b896540f970d43301d8e2b1090ac57bbd9a"
    sha256 cellar: :any,                 monterey:       "547f71cd6e18f9a5ca07d80de73b798dd706a066176e82f22a7504384abc6ee2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8af9600649b189179e7a69a4bfa0f5c0a58e571fb5a3ef7d9bc86f171cf88011"
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
