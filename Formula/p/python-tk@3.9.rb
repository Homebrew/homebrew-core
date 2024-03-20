class PythonTkAT39 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.9.19/Python-3.9.19.tar.xz"
  sha256 "d4892cd1618f6458cb851208c030df1482779609d0f3939991bd38184f8c679e"
  license "Python-2.0"

  livecheck do
    formula "python@3.9"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6cf17300caeb9de0bedcb9be19b4f91ddc8e1ed02a05bac1dede7b89ec6e019e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "239544d688c136aa332a7cf19b099c8bb7c1ed18b935c91e7aae10838ed735f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8feaaf7a0a9a189c4c4501b2b615c0593cd72c893c66931a12ac11db8422f528"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7880e183e7cdb45d62abcffff5cc40b17cba08aab202dfdd4a149760b99737a7"
    sha256 cellar: :any,                 sonoma:         "ab7b792e607b5109719c52c03c3c5e9973ecf495b4bf42d79310ce9325765be0"
    sha256 cellar: :any_skip_relocation, ventura:        "81664ef3893a689b3af8405fabb344e2d16fbad7ac802c3ae4758f558014b7b7"
    sha256 cellar: :any_skip_relocation, monterey:       "99054c55d322d74e9998bbed0a1b79664eb0e043ade79c39e57940444b7afd95"
    sha256 cellar: :any_skip_relocation, big_sur:        "e21545af299a2aec6b9847815395df053cf169f7c6a53e709d2f11de4766c434"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01e4e20eb6d8e953f0b68776e7c48a89e7946dac0830842b8679e55d953c5c4d"
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
      system python3, *Language::Python.setup_install_args(libexec), "--install-lib=#{libexec}"
      rm_r libexec.glob("*.egg-info")
    end
  end

  test do
    system python3, "-c", "import tkinter"

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system python3, "-c", "import tkinter; root = tkinter.Tk()"
  end
end
