class Pivy < Formula
  desc "Python bindings to coin3d"
  homepage "https://github.com/coin3d/pivy"
  url "https://github.com/coin3d/pivy/archive/refs/tags/0.6.10.tar.gz"
  sha256 "7b409816c9fad84cf94f93659281f9dd2501d285eb2fc609e9401a3d004ce723"
  license "ISC"
  head "https://github.com/coin3d/pivy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "8b87dac25665d8517854cb34f96c4e9237495781555a4eb8c8de59a1c6476037"
    sha256 cellar: :any,                 arm64_ventura: "0378b486fef297474f82175e844633a21a00772f523acc0f84ccf97e368ce143"
    sha256 cellar: :any,                 sonoma:        "d9f23884af3e774e654ee22911feeed221e02f3d829f94d8f95582fb2997b9b1"
    sha256 cellar: :any,                 ventura:       "73bc75f176e815f882879135054ac7e018482292250f8101a9206b12156bb7f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0f07d2aca7c37e78d292ef734d91d07bd5fad4adf46359a0a86123fd82fabbd"
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "coin3d"
  depends_on "pyside"
  depends_on "python@3.13"
  depends_on "qt"

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
