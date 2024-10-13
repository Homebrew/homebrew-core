class PythonTkAT39 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.9.20/Python-3.9.20.tar.xz"
  sha256 "6b281279efd85294d2d6993e173983a57464c0133956fbbb5536ec9646beaf0c"
  license "Python-2.0"

  livecheck do
    formula "python@3.9"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "69337728fbfe63387f3ee052e3cf13bcfea91fff4932594d8c568e5fc028b5a6"
    sha256 cellar: :any,                 arm64_sonoma:   "d3e96db3185c125a680051a4984927651a69d9ecc832189f97f1c422944d9484"
    sha256 cellar: :any,                 arm64_ventura:  "70aeb0283d3308c7a1f3a0ef6895c212499e9e3de7dc2892c815665d1e5a0a9e"
    sha256 cellar: :any,                 arm64_monterey: "46c8166a4af72baa91d6ab36862fe0cd2acdef77813cd31e9658a4b94d808456"
    sha256 cellar: :any,                 sonoma:         "e32cc2c7f3aca1968c0038ea6f001f0eb804b55548bfe0f7205d4b21c2180a79"
    sha256 cellar: :any,                 ventura:        "5e1a52536fa875ec37b7a4ea42474ae8e1c13dea57f2973ce5db489685fd331f"
    sha256 cellar: :any,                 monterey:       "93ef0db67efabc9e0f9ece2d93735baa7a1f315a26bed1dbcbb19bc39fe2b8d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10b7ce74afeed87b5374e042a7bb0a6d7db6e6a019815fc607e20c628217856d"
  end

  depends_on "python@3.9"
  depends_on "tcl-tk"

  def python3
    "python3.9"
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
      system python3, "-m", "pip", "install", *std_pip_args(prefix: false), "--target=#{libexec}", "."
      rm_r libexec.glob("*.dist-info")
    end
  end

  test do
    system python3, "-c", "import tkinter"

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system python3, "-c", "import tkinter; root = tkinter.Tk()"
  end
end
