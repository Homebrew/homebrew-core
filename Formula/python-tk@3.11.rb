class PythonTkAT311 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.4/Python-3.11.4.tgz"
  sha256 "85c37a265e5c9dd9f75b35f954e31fbfc10383162417285e30ad25cc073a0d63"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "18138527b22efdf48a841094b98aacb58dfaeff84513622054859048b0185869"
    sha256 cellar: :any,                 arm64_monterey: "073dd807274d72fc44246d10a8863d214f8fec0185b3e14dfbfde3efa0ada67e"
    sha256 cellar: :any,                 arm64_big_sur:  "3ad3a5bdf1042e2327e5a47d9b42b18308b99a58dfc553d1e45e14d8ebeed242"
    sha256 cellar: :any,                 ventura:        "23696e881fd3cf3dac5626a5acbc0f83860a0838905ee829534c1a27076448fd"
    sha256 cellar: :any,                 monterey:       "2f10060f14e59204a42a72a38c2210fe322e7fdda4209815e2f06d18a112d348"
    sha256 cellar: :any,                 big_sur:        "4b64ace86b3a5e97731044939fbf8a6437ad059104e21c25b7f3ae2141ecccfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08113116080ba01ee72766d9dbaf28a014444d6c8f0fb51c14d918f4bf844e03"
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
