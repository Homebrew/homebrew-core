class Pivy < Formula
  desc "Python bindings to coin3d"
  homepage "https://github.com/coin3d/pivy"
  url "https://github.com/coin3d/pivy/archive/refs/tags/0.6.10.tar.gz"
  sha256 "7b409816c9fad84cf94f93659281f9dd2501d285eb2fc609e9401a3d004ce723"
  license "ISC"
  head "https://github.com/coin3d/pivy.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "cbb8303807dc68efa785a595b464ea44c17aa17c5811848d26a4ffefdeaf6783"
    sha256 cellar: :any,                 arm64_sequoia: "711d681b19f5b4b6277890b04c480ef1fbfd8c7f5529c6628004fc1d057553b9"
    sha256 cellar: :any,                 arm64_sonoma:  "90c2d18f4261f8f4c65405dc18f32c322b03f24504bdff55c03608e2e5c53762"
    sha256 cellar: :any,                 sonoma:        "f8b2a7c238524c232c368b45c0ac5761e56e794970b79fe7a84d31efdda7e4a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "735ebf4fddd4b49343e5baf4e60580f3e2134d13f7bbbc36b18011fbe549206a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58037db476464761029fa53f2c5a2365dbe2e4fcb87ef993556cb3b2fa1400ac"
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "coin3d"
  depends_on "pyside"
  depends_on "python@3.13" # `pyside` is not yet support for Python 3.14
  depends_on "qtbase"

  def python3
    "python3.13"
  end

  def install
    site_packages = prefix/Language::Python.site_packages(python3)
    rpaths = [rpath(source: site_packages/"pivy"), rpath(source: site_packages/"pivy/gui")]

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
                    "-DPython_EXECUTABLE=#{which(python3)}",
                    "-DPIVY_Python_SITEARCH=#{site_packages}",
                    "-DPIVY_USE_QT6=ON",
                    *std_cmake_args(find_framework: "FIRST")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error:
    # "This application failed to start because no Qt platform plugin could be initialized."
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system python3, "-c", <<~PYTHON
      import shiboken6
      from pivy.quarter import QuarterWidget
      from pivy.sogui import SoGui
      assert SoGui.init("test") is not None
    PYTHON
  end
end
