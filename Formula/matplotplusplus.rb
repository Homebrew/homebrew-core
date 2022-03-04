class Matplotplusplus < Formula
  desc "C++ Graphics Library for Data Visualization"
  homepage "https://github.com/alandefreitas/matplotplusplus"
  url "https://github.com/alandefreitas/matplotplusplus/archive/v1.1.0.tar.gz"
  sha256 "5c3a1bdfee12f5c11fd194361040fe4760f57e334523ac125ec22b2cb03f27bb"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_monterey: "d42150d2d9d53a6bef53f5ceec0574d856617c1a4cd71a34e0b50bd70a01b7e1"
    sha256 cellar: :any, arm64_big_sur:  "19cb7c2dd1eb682773ab6022a5eeeedcfe423765eccba27ab9d5f2124db7fdab"
    sha256 cellar: :any, monterey:       "2c58c5d6e887522aefe006a3e6caaff906efd3c586e918d60d75b74fa0629496"
    sha256 cellar: :any, big_sur:        "4179a851403a2af2264efa5b766b708c256f66b37680a8ebcf1f5c2f9b4b3866"
    sha256 cellar: :any, catalina:       "52ae1b2728e95782080b211eef063972aac7751e02f1714a9dc41d57c5ddcdaa"
    sha256 cellar: :any, mojave:         "4cdcc03dcf7ffaed40caf7e052de33836e195c375585d13e73d3a720bf61cb84"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "gnuplot"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openexr"

  fails_with :clang do
    build 1100
    cause "cannot run simple program using std::filesystem"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
      system "make"
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/exporting/save/save_1.cpp", testpath/"test.cpp"
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lmatplot", "-o", "test"
    system "./test"
    assert_predicate testpath/"img/barchart.svg", :exist?
  end
end
