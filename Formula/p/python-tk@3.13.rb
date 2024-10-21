class PythonTkAT313 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.13.0/Python-3.13.0.tgz"
  sha256 "12445c7b3db3126c41190bfdc1c8239c39c719404e844babbd015a1bc3fafcd4"
  license "Python-2.0"

  livecheck do
    formula "python@3.13"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a2fc4369faf0fb37a7ae8d084d22575ad5df6e1233b19f9c2ce6306d127ffcd3"
    sha256 cellar: :any,                 arm64_sonoma:  "57c56999cea8171bf660003e2438ee057fc08cb84d1511093a4576f59d0e4102"
    sha256 cellar: :any,                 arm64_ventura: "be949a35a3c48cfa085d2b3a2f6a75ba9b9d966ad72da490ab1e24adbfdb3717"
    sha256 cellar: :any,                 sonoma:        "442e5b38e2d265463cd638b2239ed8710e2e002730314979d277b0ef2b9977d5"
    sha256 cellar: :any,                 ventura:       "4e67ed99e89f8a8c17f8b93d4f44d592a7f328b008a024fd6755bec4f838542a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df54524e5b9884f26e59757cb9b720206535b14ab21d99451ebd17b15fb3d09c"
  end

  depends_on "python@3.13"
  depends_on "tcl-tk"

  def python3
    "python3.13"
  end

  def install
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
      system python3, "-m", "pip", "install", *std_pip_args(prefix: false, build_isolation: true),
                                              "--target=#{libexec}", "."
      rm_r libexec.glob("*.dist-info")
    end
  end

  test do
    system python3, "-c", "import tkinter"

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system python3, "-c", "import tkinter; root = tkinter.Tk()"
  end
end
