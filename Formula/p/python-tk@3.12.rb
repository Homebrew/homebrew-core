class PythonTkAT312 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.12.3/Python-3.12.3.tgz"
  sha256 "a6b9459f45a6ebbbc1af44f5762623fa355a0c87208ed417628b379d762dddb0"
  license "Python-2.0"

  livecheck do
    formula "python@3.12"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8183c2f16ea227f9764728e4d5eb45b8a70d0dd5fa8d23a610ed938ed5f0dbf9"
    sha256 cellar: :any,                 arm64_ventura:  "7fb68ab63254951b84476ff9ae58c232329bf9d69c815302fd0cfd140d057685"
    sha256 cellar: :any,                 arm64_monterey: "ff58c9ce8378903bb7b61ed5f96ab4e3ea868854b7f48b2dd21b45ab3a17b85f"
    sha256 cellar: :any,                 sonoma:         "834d1e4002d6e232d72624d4ba6708330da316e12a56cd9bcba09a1f9d7b14ae"
    sha256 cellar: :any,                 ventura:        "c13d81778aeb5e5095323873579882dc881889c2561779007b7f03f5846e490a"
    sha256 cellar: :any,                 monterey:       "9ccb3808203f0e1f39b8f6b00ca3022c773b08685c42f78baab8a1bd0748c475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4850bcf634b3675e9c5653099a6cd2e1f12317a9ffe3d9fc63b3b55b75a5fe0"
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
