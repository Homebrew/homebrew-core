class PythonTkAT312 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.12.4/Python-3.12.4.tgz"
  sha256 "01b3c1c082196f3b33168d344a9c85fb07bfe0e7ecfe77fee4443420d1ce2ad9"
  license "Python-2.0"

  livecheck do
    formula "python@3.12"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d81a66f917b4b252349f94ed92d318332b1ae698e61e60e31e885b560338221c"
    sha256 cellar: :any,                 arm64_ventura:  "cef9cd137c18dd1e517efc441fed69ebf9a99e408babdf67bfd8f61a843cf536"
    sha256 cellar: :any,                 arm64_monterey: "021376122320e526633d55119477293384d0ea645f9aa72bdf2658f9895303df"
    sha256 cellar: :any,                 sonoma:         "0e0e915fc859859188ca9b40317df78cd202fec365ef7493ccc22d664caef40e"
    sha256 cellar: :any,                 ventura:        "d4bd816b48f44a983991a6f6f9fb31ad11d6b039daaa612d172fb948b5815658"
    sha256 cellar: :any,                 monterey:       "dc4ced05a349f822f4e770f7552c1e492ea7f476ea129dd2cccc1e8a4be3799e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b75da4ee04bbb4f59e879917d8a95961d488d0314cf26d681841d7ed0ab9cb8f"
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
