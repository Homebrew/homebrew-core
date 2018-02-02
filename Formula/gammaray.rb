class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/kdab-products/gammaray/"
  url "https://github.com/KDAB/GammaRay/releases/download/v2.8.2/gammaray-2.8.2.tar.gz"
  sha256 "da7ffb6747b958f6e8ca3aed530bf8f4254407127704cf236bc9a099e4f5fff0"
  head "https://github.com/KDAB/GammaRay.git"

  bottle do
    sha256 "8116210bfc9f845fac99f46222fb787dfb25c61935c0bd9537f1f022936ba044" => :high_sierra
    sha256 "f81cdf19b17f3b09c5c0ed484e6d97d902bb93b7426cf96af02e26e24c14a915" => :sierra
    sha256 "89a951178fc9bc16ab8f46a6f6e29683c855bea9aa37f9e3acafee5701fff366" => :el_capitan
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
