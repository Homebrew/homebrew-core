class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/kdab-products/gammaray/"
  url "https://github.com/KDAB/GammaRay/releases/download/v2.8.1/gammaray-2.8.1.tar.gz"
  sha256 "b01533a524d6f66e4e15d94b7528c7c4d6d8dfc104621849be6155df6b52fc3f"
  head "https://github.com/KDAB/GammaRay.git"

  bottle do
    sha256 "edaf5e2f136cae40a09d16165e3f4b178251fa938603e3f26132458c84ceeba5" => :sierra
    sha256 "4ff4974627728b9289ddc31394c1e5bb612bfc28a40dacf365ee4c31d7e33b24" => :el_capitan
    sha256 "12ad2449434c9c7752a2b8a4b40c537008ba29efbc03a1840714b7ef7f51a23b" => :yosemite
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
    (prefix/"GammaRay.app/Contents/MacOS/gammaray").executable?
  end
end
