class Matplotplusplus < Formula
  desc "C++ Graphics Library for Data Visualization"
  homepage "https://github.com/alandefreitas/matplotplusplus"
  url "https://github.com/alandefreitas/matplotplusplus/archive/v1.0.1.tar.gz"
  sha256 "19f5f6fe40b56efc49dcda7f6c6de07679f5707254dea6859c3c7b4a8a0759a3"
  license "MIT"

  bottle do
    cellar :any
    sha256 "a1f77bf8f309843d278ea940822578bf48d2aaf9697566ed46287a20ad1896bb" => :big_sur
    sha256 "979279ad16e5e814b368c88c46cc5d995367c245100b033fade178ef3ab3cbeb" => :arm64_big_sur
    sha256 "e24805c80b41e2d9957c1757e3f7cb329b39302127eeced2c81c9091487986db" => :catalina
    sha256 "e522028527552e68faedc2377ff419ea08986b10f0a5b74e1f573537e99ee41c" => :mojave
    sha256 "c17c5db0287c73c0d126c0d459a32c1c56ebb702e19f8c53f8d8d91880dfc75a" => :high_sierra
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
