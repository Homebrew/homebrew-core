class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/kdab-products/gammaray/"
  url "https://github.com/KDAB/GammaRay/releases/download/v2.9.1/gammaray-2.9.1.tar.gz"
  sha256 "ba1f6f2b777c550511a17f704b9c340df139de8ba8fa0d72782ea51d0086fa47"
  head "https://github.com/KDAB/GammaRay.git"

  bottle do
    sha256 "90dea0a6374d27a768d2ad6d5cf4b70751199924d2dfb6d47af71fd2d638bb8a" => :high_sierra
    sha256 "96fbf0b78d74f59b2be7399aa0a2a5f0c2d89629e930ef236e2280d514914218" => :sierra
    sha256 "d3295f75b82219d58cd8f529e6f0e72bf8d798321f50b55ba7418af48b624060" => :el_capitan
  end

  option "with-vtk", "Build with VTK-with-Qt support, for object 3D visualizer"

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "qt"
  depends_on "graphviz" => :recommended

  def install
    # For Mountain Lion
    ENV.libcxx

    args = std_cmake_args
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_VTK=" + (build.without?("vtk") ? "ON" : "OFF")
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_Graphviz=" + (build.without?("graphviz") ? "ON" : "OFF")

    system "cmake", *args
    system "make", "install"
  end

  test do
    assert_predicate prefix/"GammaRay.app/Contents/MacOS/gammaray", :executable?
  end
end
