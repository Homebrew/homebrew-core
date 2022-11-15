class PythonTkAT39 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.9.15/Python-3.9.15.tar.xz"
  sha256 "12daff6809528d9f6154216950423c9e30f0e47336cb57c6aa0b4387dd5eb4b2"
  license "Python-2.0"

  livecheck do
    formula "python@3.9"
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "6e4fdcd1e7342394a2da4f1c6ceb8ed4c2ac540ff1b3e496dc148574e1402730"
    sha256 cellar: :any, arm64_monterey: "24dc7d6c49d431eff030f1749f4b3d6432052a2fde4299aa9c13eb19ce7cb8df"
    sha256 cellar: :any, arm64_big_sur:  "811d8739853753f49d2079e19603e68f17265a56716c6f137cfcf52723631f80"
    sha256 cellar: :any, ventura:        "63acc24ce6099238690bc2a4a7f78b68773c39bf94f0e7db31d76bb6594b9091"
    sha256 cellar: :any, monterey:       "d5a742fcc6d2eadd624ba68097d1a86f2a32cceab5e15dd5b2079a4f537cdbaa"
    sha256 cellar: :any, big_sur:        "b3c734d61fd58a594b86a5a439b646740266ba141e8c7191eddef90115842392"
    sha256 cellar: :any, catalina:       "0105632047409a2dfa98559ed508a401fa5ec92eb3955a8fde977d67a24057aa"
    sha256               x86_64_linux:   "46e7b013ea5af21270a7455fe35ac218227499df6f974f11af4324707dacdb53"
  end

  depends_on "python@3.9"
  depends_on "tcl-tk"

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
                          include_dirs=["#{Formula["tcl-tk"].opt_include}"],
                          libraries=["tcl#{tcltk_version}", "tk#{tcltk_version}"],
                          library_dirs=["#{Formula["tcl-tk"].opt_lib}"])
              ]
        )
      EOS
      system "python3.9", *Language::Python.setup_install_args(libexec), "--install-lib=#{libexec}"
      rm_r libexec.glob("*.egg-info")
    end
  end

  test do
    system "python3.9", "-c", "import tkinter"

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "python3.9", "-c", "import tkinter; root = tkinter.Tk()"
  end
end
