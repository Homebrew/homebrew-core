class PythonTkAT311 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.6/Python-3.11.6.tgz"
  sha256 "c049bf317e877cbf9fce8c3af902436774ecef5249a29d10984ca3a37f7f4736"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "82f8a3f731795819f9c18c2330f5abc42611733ad35b2a7db811636bd92c6e22"
    sha256 cellar: :any,                 arm64_ventura:  "6ea2f81c2e150349fc5951e70f49110aeee7329c0b2801790b4542474f2bfc0e"
    sha256 cellar: :any,                 arm64_monterey: "71f92b872e09325c0dbe692b3dc96ccca0d2992775a29a03089340e9f58ee982"
    sha256 cellar: :any,                 sonoma:         "802cd4898d8d6d1ca96a627f2868f87989a31e7436023ca8d4e26a583bda04f3"
    sha256 cellar: :any,                 ventura:        "294982cae5133b52513efbe6d1850a74a1e67eec4db1f48c6dbfffee7c2e58f4"
    sha256 cellar: :any,                 monterey:       "8a2216212d2c38041482d43719ccda808b0be37d43d43576cb541a6e44705c41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28819314ceecc86581d697024b0e5559c8fa8dede8d7c7dda24099128ba64298"
  end

  depends_on "python@3.11"
  depends_on "tcl-tk"

  def python3
    "python3.11"
  end

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
                          include_dirs=["#{Formula["tcl-tk"].opt_include/"tcl-tk"}"],
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
