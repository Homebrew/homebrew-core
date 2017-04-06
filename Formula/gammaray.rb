class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/kdab-products/gammaray/"
  url "https://github.com/KDAB/GammaRay/releases/download/v2.7.0/gammaray-2.7.0.tar.gz"
  sha256 "09b814a33a53ae76f897ca8a100af9b57b08807f6fc2a1a8c7889212ee10c83b"
  revision 1
  head "https://github.com/KDAB/GammaRay.git"

  bottle do
    sha256 "d1af9cd107a4a4642454740e85a7f66eba9304b87730f99d7855c7d7ad85cb9c" => :sierra
    sha256 "a6401a339daf49e469ad77cecfbc6047d18037d92be773ecea7c3ad4697eb213" => :el_capitan
    sha256 "fa784ae5c7cd568861f1ea75d9822240ad3b0e81d797ff7490d2f7c67434e64a" => :yosemite
  end

  option "with-vtk", "Build with VTK-with-Qt support, for object 3D visualizer"

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "qt"
  depends_on "graphviz" => :recommended

  # VTK needs to have Qt support, and it needs to match GammaRay's
  depends_on "homebrew/science/vtk" => [:optional, "with-qt5"]

  def install
    # For Mountain Lion
    ENV.libcxx

    args = std_cmake_args
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_VTK=" + ((build.without? "vtk") ? "ON" : "OFF")
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_Graphviz=" + ((build.without? "graphviz") ? "ON" : "OFF")

    system "cmake", *args
    system "make", "install"
  end

  test do
    (prefix/"GammaRay.app/Contents/MacOS/gammaray").executable?
  end
end
