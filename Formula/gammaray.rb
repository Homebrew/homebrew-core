class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/kdab-products/gammaray/"
  url "https://github.com/KDAB/GammaRay/releases/download/v2.8.0/gammaray-2.8.0.tar.gz"
  sha256 "8d033f50ea62f9ff804cc4b8fa40b03f21c23481b4a98d03a65cc718124476c5"
  head "https://github.com/KDAB/GammaRay.git"

  bottle do
    sha256 "76e7c07edc886ce6c7f14897285db185fe0e94964c1d5742ac66df177e400942" => :sierra
    sha256 "ed43e7b0c27ba001d9067330ee0c7304128da73b3d6db493115f5fa35d927a8a" => :el_capitan
    sha256 "3a28321d6a5570f04896ddb9def1e0f02d479586b85d84a6e598c42fce88343c" => :yosemite
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
