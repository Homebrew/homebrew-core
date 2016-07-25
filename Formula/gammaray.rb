class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/kdab-products/gammaray/"
  url "https://github.com/KDAB/GammaRay/releases/download/v2.4.1/gammaray-2.4.1.tar.gz"
  sha256 "08b151eaa4afeaaebc28eaae789f8da47d99012f1071f19d20d8d4d91115b6ab"
  head "https://github.com/KDAB/GammaRay.git"

  bottle do
    sha256 "64e1e4a6899533050f5827e5d3ef1806a2b3e283915216038d911d8d7aaab44c" => :el_capitan
    sha256 "c608bb460f08a11ebac9fa5c6bbe03c382d6dae8de401ce1de183c0182551607" => :yosemite
    sha256 "3e9f72fdf6d8a58ccfc25f75fd94fb215417e7edd28790b45f031e700508049a" => :mavericks
  end

  option "with-vtk", "Build with VTK-with-Qt support, for object 3D visualizer"
  option "with-test", "Verify the build with `make test`"

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "qt5"
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
    system "make"
    system "make", "test" if build.bottle? || build.with?("test")
    system "make", "install"
  end

  test do
    (prefix/"GammaRay.app/Contents/MacOS/gammaray").executable?
  end
end
