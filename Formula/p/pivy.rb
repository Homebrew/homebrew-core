class Pivy < Formula
  desc "Python bindings to coin3d"
  homepage "https://github.com/coin3d/pivy"
  url "https://github.com/coin3d/pivy/archive/refs/tags/0.6.11.tar.gz"
  sha256 "78f79bd7d1ce7e8140ceba4b1220136ea1f14b4403b1e463c59fa892feed961e"
  license "ISC"
  revision 1
  head "https://github.com/coin3d/pivy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e15c0bcda241db1537f3b25f0b0a604f698d6775d18650d3c88be1e55e370aab"
    sha256 cellar: :any, arm64_tahoe:       "7195cf00c873129d21b662233a291bca0049920e85208993db49b884b6ead1af"
    sha256 cellar: :any, arm64_sequoia:     "1d3cf17966d63736ca2ccf59082d6bfe0390535f933ca9aacf1a893bd6f9198f"
    sha256 cellar: :any, arm64_linux:       "ba4ce313da93419e306a11286cb123e4d7d927f4c002e180f8ed30408389c24e"
    sha256 cellar: :any, x86_64_linux:      "2bb3504c32f17abe77daf1db75107e3a5dcb436f8604fa672b60dd2bb3ed23a9"
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "coin3d"
  depends_on "pyside"
  depends_on "python@3.15"
  depends_on "qtbase"

  # Apply FreeCAD fork's fixes for newer Swig. Part of https://github.com/coin3d/pivy/pull/149
  patch do
    url "https://github.com/coin3d/pivy/commit/7040f5b8e2a04a23e2bc3eb07844ee5fb87564a7.patch?full_index=1"
    sha256 "3e45d484a86dba35b0635259816e7e16b8aebd737130f683eacdadedc92d4b9b"
    type :unofficial
  end
  patch do
    url "https://github.com/coin3d/pivy/commit/92c11bab021395a589819b3e31c36417128d5f77.patch?full_index=1"
    sha256 "3c3223ccf98481b6af802aa282c288aa66083080ec7f9989c567c96f1b7ee450"
    type :unofficial
  end

  deny_network_access!

  def install
    site_packages = prefix/Language::Python.site_packages(python3)
    rpaths = [rpath(source: site_packages/"pivy"), rpath(source: site_packages/"pivy/gui")]

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
                    "-DPython_EXECUTABLE=#{python3}",
                    "-DPIVY_Python_SITEARCH=#{site_packages}",
                    "-DPIVY_USE_QT6=ON",
                    *std_cmake_args(find_framework: "FIRST")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error:
    # "This application failed to start because no Qt platform plugin could be initialized."
    ENV["QT_QPA_PLATFORM"] = "minimal"

    system python3, "-c", <<~PYTHON
      import shiboken6
      from pivy.quarter import QuarterWidget
      from pivy.sogui import SoGui
      assert SoGui.init("test") is not None
    PYTHON
  end
end
