class Matplotplusplus < Formula
  desc "C++ Graphics Library for Data Visualization"
  homepage "https://github.com/alandefreitas/matplotplusplus"
  url "https://github.com/alandefreitas/matplotplusplus/archive/v1.1.0.tar.gz"
  sha256 "5c3a1bdfee12f5c11fd194361040fe4760f57e334523ac125ec22b2cb03f27bb"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1931cf92f8b391d3a193d635314dc20737e3eb706ec5f6d2dc4bfb2b07df84e3"
    sha256 cellar: :any, big_sur:       "c61f1d125f44e9d58965ef1432cebff43ffac2d8e819f1cc1271459115a591c5"
    sha256 cellar: :any, catalina:      "7c3b3ea25fa94f5e01cf48086afb821f57b414d4b3572ee7693363ae0e389440"
    sha256 cellar: :any, mojave:        "bd4c620d7a8f565b53ec83703e1760d96830de15c2ce1877d05c98925ca04be7"
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
