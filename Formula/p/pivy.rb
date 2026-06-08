class Pivy < Formula
  desc "Python bindings to coin3d"
  homepage "https://github.com/coin3d/pivy"
  url "https://github.com/coin3d/pivy/archive/refs/tags/0.6.11.tar.gz"
  sha256 "78f79bd7d1ce7e8140ceba4b1220136ea1f14b4403b1e463c59fa892feed961e"
  license "ISC"
  head "https://github.com/coin3d/pivy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3c3efc4969c94db900ff5a8d2e564792db5b2aa0b17d687f441e29d654e872bf"
    sha256 cellar: :any,                 arm64_sequoia: "4ad65036fd17e5f291383b618d1d4d0a372a424baf46db6f9d5660350bb2099f"
    sha256 cellar: :any,                 arm64_sonoma:  "bafa801b126aec60325b9a44060cffa929b2cbb064b2799972868f6b5a0cd51c"
    sha256 cellar: :any,                 sonoma:        "8d401a42d19e519d79fceb13e776808a6f249b52c054ee464e18fdc20730e872"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9f4842d2e3d7cda6a5576989b3f99c80904831dafc11953ce1091e80b6384db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fec926400c3514af60807399894ac76d0a0f1251795b36d512c9aa50ef2240d7"
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
