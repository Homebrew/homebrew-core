class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/kdab-products/gammaray/"
  url "https://github.com/KDAB/GammaRay/releases/download/v2.7.0/gammaray-2.7.0.tar.gz"
  sha256 "09b814a33a53ae76f897ca8a100af9b57b08807f6fc2a1a8c7889212ee10c83b"
  head "https://github.com/KDAB/GammaRay.git"

  bottle do
    sha256 "40abbbf3706bcd8671fae35f7e53397b090895d9022e7f1dc1370d572342a87a" => :sierra
    sha256 "b289c07b23b494f2d9442e77dedfda8227982cdf184e938cbc248454db85b272" => :el_capitan
    sha256 "3c4094ed9c841a17de8a87f696f038c99f1e532bd3de13664068cb7bc5ab623a" => :yosemite
  end

  option "with-vtk", "Build with VTK-with-Qt support, for object 3D visualizer"

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
    system "make", "install"
  end

  test do
    (prefix/"GammaRay.app/Contents/MacOS/gammaray").executable?
  end
end
