class PythonTkAT314 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.14.2/Python-3.14.2.tgz"
  sha256 "c609e078adab90e2c6bacb6afafacd5eaf60cd94cf670f1e159565725fcd448d"
  license "Python-2.0"

  livecheck do
    formula "python@3.14"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f6e0a56b4fa5227265faa5525c6868b67874480b9fa1ca580e5e17baa90c3b3f"
    sha256 cellar: :any, arm64_sequoia: "f337a23a7a4d53223e876bc4a10872722cc2a2ffad91b6729fd9f7aa2dd74ed9"
    sha256 cellar: :any, arm64_sonoma:  "9bd4194bbf52afd09ffd53d7da8995ce4d377fbb6a48932f27470dff183893c6"
    sha256 cellar: :any, sonoma:        "1ce9e10040896beb28b819727b79a979e5aeeb8b3c03239e7ca9664feb0bab12"
    sha256               arm64_linux:   "552f220ee2788ae7f167d25c1d15c54d103c9ed8326361808641ac89f1fb656b"
    sha256               x86_64_linux:  "297c6f6136d901aa255f06d0fd84a8e88ea6b15fc7baefa92bb7454eca928669"
  end

  depends_on "python@3.14"
  depends_on "tcl-tk"

  def python3
    "python3.14"
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
      Pathname("setup.py").write <<~PYTHON
        from setuptools import setup, Extension

        setup(name="tkinter",
              description="#{desc}",
              version="#{version}",
              ext_modules = [
                Extension("_tkinter", ["_tkinter.c", "tkappinit.c"],
                          define_macros=[("WITH_APPINIT", 1), ("TCL_WITH_EXTERNAL_TOMMATH", 1)],
                          include_dirs=["#{python_include}/internal", "#{Formula["tcl-tk"].opt_include/"tcl-tk"}"],
                          libraries=["tcl#{tcltk_version}", "tcl#{tcltk_version.major}tk#{tcltk_version}"],
                          library_dirs=["#{Formula["tcl-tk"].opt_lib}"])
              ]
        )
      PYTHON
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
