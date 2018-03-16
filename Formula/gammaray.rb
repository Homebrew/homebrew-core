class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/kdab-products/gammaray/"
  url "https://github.com/KDAB/GammaRay/releases/download/v2.9.0/gammaray-2.9.0.tar.gz"
  sha256 "5ab3fb4ac3d7e82f37ed7c62e063505d52334338460cf31d91c99d485d1d7bc2"
  head "https://github.com/KDAB/GammaRay.git"

  bottle do
    sha256 "c4c39dad3bfc1804ce1e3ab27fdcdee8c20c6f96ce0a61cfcadcef1492445248" => :high_sierra
    sha256 "0eb1c1efd97b4cd42c1d04d99d5fade4fd277d7343fc3704f3985373d4fb7b50" => :sierra
    sha256 "f456dd66c54937c2472d613f45e6112192f583c7dea6d879ad1b3da3cde04a83" => :el_capitan
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
