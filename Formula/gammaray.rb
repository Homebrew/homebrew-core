class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/kdab-products/gammaray/"
  url "https://github.com/KDAB/GammaRay/releases/download/v2.7.0/gammaray-2.7.0.tar.gz"
  sha256 "09b814a33a53ae76f897ca8a100af9b57b08807f6fc2a1a8c7889212ee10c83b"
  revision 1
  head "https://github.com/KDAB/GammaRay.git"

  bottle do
    sha256 "49b9693517b4464312c5240921015c8795574877cc0cc2ad00f5fbabfbb347ee" => :sierra
    sha256 "36399292449e6125e1843365fcae366e68ecf1d0610b2a22836bdfb01924a770" => :el_capitan
    sha256 "ac058868dde7954847d474a1f79a17c7ea1828b83402c3337b071e5e6f6a14be" => :yosemite
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
