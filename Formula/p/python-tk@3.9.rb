class PythonTkAT39 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.9.25/Python-3.9.25.tar.xz"
  sha256 "00e07d7c0f2f0cc002432d1ee84d2a40dae404a99303e3f97701c10966c91834"
  license "Python-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "63478fc978d0b0b41290c3c0e18c7bcaa497c174fc9ce820d350692e0601d71f"
    sha256 cellar: :any, arm64_tahoe:       "80211d3a9159e78e2cd78e0493b7d34b8cbaf0ef1cb4a565cdcb5808bdae1e12"
    sha256 cellar: :any, arm64_sequoia:     "98aa6a596cf7d748a60f2e89d764f41a8d8a783a966f536a26894c8e978a6951"
    sha256 cellar: :any, arm64_linux:       "68988da196ca401a9ba9e2c595945d5d9ae6b7f3fccb4ded1e357b915068efed"
    sha256 cellar: :any, x86_64_linux:      "3cebf85829b71ee39c478b2bd23428519c936bc0ec8ed2e84a63e581955983d1"
  end

  # Follow up to python@3.9 deprecation
  deprecate! date: "2025-10-15", because: :deprecated_upstream
  disable! date: "2026-10-15", because: :deprecated_upstream

  depends_on "python@3.9"
  depends_on "tcl-tk@8"

  deny_network_access!

  def install
    cd "Modules" do
      tcltk = Formula["tcl-tk@8"]
      tcltk_version = tcltk.any_installed_version.major_minor
      Pathname("setup.py").write <<~PYTHON
        from setuptools import setup, Extension

        setup(name="tkinter",
              description="#{desc}",
              version="#{version}",
              ext_modules = [
                Extension("_tkinter", ["_tkinter.c", "tkappinit.c"],
                          define_macros=[("WITH_APPINIT", 1)],
                          include_dirs=["#{tcltk.opt_include/"tcl-tk"}"],
                          libraries=["tcl#{tcltk_version}", "tk#{tcltk_version}"],
                          library_dirs=["#{tcltk.opt_lib}"])
              ]
        )
      PYTHON
      args = std_pip_args(prefix: false, build_isolation: false).reject { |s| s["--uploaded-prior-to"] }
      system python3, "-m", "pip", "install", *args, "--target=#{libexec}", "."
      rm_r libexec.glob("*.dist-info")
    end
  end

  test do
    system python3, "-c", "import tkinter"
  end
end
