class PythonTkAT312 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.12.7/Python-3.12.7.tgz"
  sha256 "73ac8fe780227bf371add8373c3079f42a0dc62deff8d612cd15a618082ab623"
  license "Python-2.0"
  revision 1

  livecheck do
    formula "python@3.12"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b74d20895d8265b5d1b516b15f4635a08292dc9bba5320e3431175404d0eff55"
    sha256 cellar: :any,                 arm64_sonoma:  "bb2896eee554c65ff8f090d1b735069f18c5173eacdf48f6ce611ac40830e158"
    sha256 cellar: :any,                 arm64_ventura: "8d5187355e686dd00bc67d34eabea5de4322f895481b93b59cfbcd69e934acbb"
    sha256 cellar: :any,                 sonoma:        "ea617358b902cd7dbb8d707ec2c8c8b64504e4477bd144c0d46eb4eef1e083b8"
    sha256 cellar: :any,                 ventura:       "bdc83ffabea42a940aaf23c565d73769daa27661c297d925e40d10ff0d8d581a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1183fd08283e6b54d53ea9673dc38bd22a3546082b66be835d711bd46dc372f7"
  end

  depends_on "python@3.12"
  depends_on "tcl-tk"

  def python3
    "python3.12"
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
      Pathname("setup.py").write <<~EOS
        from setuptools import setup, Extension

        setup(name="tkinter",
              description="#{desc}",
              version="#{version}",
              ext_modules = [
                Extension("_tkinter", ["_tkinter.c", "tkappinit.c"],
                          define_macros=[("WITH_APPINIT", 1)],
                          include_dirs=["#{python_include}/internal", "#{Formula["tcl-tk"].opt_include/"tcl-tk"}"],
                          libraries=["tcl#{tcltk_version}", "tcl#{tcltk_version.major}tk#{tcltk_version}"],
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
