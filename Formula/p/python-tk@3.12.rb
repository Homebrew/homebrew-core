class PythonTkAT312 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.12.5/Python-3.12.5.tgz"
  sha256 "38dc4e2c261d49c661196066edbfb70fdb16be4a79cc8220c224dfeb5636d405"
  license "Python-2.0"

  livecheck do
    formula "python@3.12"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "38b7fcb90e6a0082a8789d70eeb0ae61d54de2987d676efc344fe17dd14700c6"
    sha256 cellar: :any,                 arm64_ventura:  "0609e81522c325d04095b51b0bf92d6be11bbe44dd009fb2dee7fc5c41d7ec7c"
    sha256 cellar: :any,                 arm64_monterey: "d4d368c705381165de46490857db1fd9ec5a6db38c557a6dece16fa6348025df"
    sha256 cellar: :any,                 sonoma:         "2763dc047daac754b0a91618406b1fc276bd70fd2c4ce5acf8246265b6046492"
    sha256 cellar: :any,                 ventura:        "e42ed3105836f36e84be9ece2a4bf93d9a2282dec92ab856d5c8401790767275"
    sha256 cellar: :any,                 monterey:       "89ac3a7b909e0e57daa5f165e74bfd5b3f65a4a7c45c111c5bfcea1084e5dfb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1e66d5c1ea22dbdbd43fc240e4e500f7ef7a48db6c84b01af456acda89b4b56"
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
