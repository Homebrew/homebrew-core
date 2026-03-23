class Pivy < Formula
  desc "Python bindings to coin3d"
  homepage "https://github.com/coin3d/pivy"
  url "https://github.com/coin3d/pivy/archive/refs/tags/0.6.10.tar.gz"
  sha256 "7b409816c9fad84cf94f93659281f9dd2501d285eb2fc609e9401a3d004ce723"
  license "ISC"
  revision 1
  head "https://github.com/coin3d/pivy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7af9cc64f5c26f519c8c8116982c84a4dd77b217c5fc91e508aa3a056e066a49"
    sha256 cellar: :any,                 arm64_sequoia: "1749994556abef4f47023dc4831c8f66d3ab5345655c971eed253d841c3daec6"
    sha256 cellar: :any,                 arm64_sonoma:  "6c70ff465259e3ea3b8b778e2afb81d664831214ab35be393b8647da04e7682e"
    sha256 cellar: :any,                 sonoma:        "50e39ab5c9e250a552c416b7b50128f5d5c3100acab15b8c5114a78a7b41ba39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f3dd2afff6c77e1501b70461fd6efd481fc601710faef30a7feb22bdca305c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5867393be9c9375ba219639d2a73a5ceab1dccc72b048f9f879ffc3ae2391cb"
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "coin3d"
  depends_on "pyside"
  depends_on "python@3.14"
  depends_on "qtbase"

  def python3
    "python3.14"
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
