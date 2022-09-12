class Matplotplusplus < Formula
  desc "C++ Graphics Library for Data Visualization"
  homepage "https://github.com/alandefreitas/matplotplusplus"
  url "https://github.com/alandefreitas/matplotplusplus/archive/v1.1.0.tar.gz"
  sha256 "5c3a1bdfee12f5c11fd194361040fe4760f57e334523ac125ec22b2cb03f27bb"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "56afbf065a28764f8d942e504a9f60a026a27fad912ef51978db8112d07afeee"
    sha256 cellar: :any,                 arm64_big_sur:  "94122a1e752952006952cd8a2e6e91718a6c4f3fa2eb6405df6946daccd66097"
    sha256 cellar: :any,                 monterey:       "91901422968fdb9879863fed4a0bc16f2d7ab64e46a2c5fd0a6fa4a89030ea71"
    sha256 cellar: :any,                 big_sur:        "743e15f040a5115d6759acfedcee64e5cc7288d6cdf58b16550235b78aa5853a"
    sha256 cellar: :any,                 catalina:       "2deb4d4428a865e69556f26b54144e631fe2f4e0344ab3eb0da21a0b634d0fda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66fa676696d45f91544653e20b6d388f8bd878c653d465ffab8a98a3fe2d4333"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "gnuplot"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openexr"

  uses_from_macos "zlib"

  fails_with :clang do
    build 1100
    cause "cannot run simple program using std::filesystem"
  end

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DBUILD_EXAMPLES=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    # Set QT_QTP_PLATFORM to "minimal" on Linux so that it does not fail with this error:
    # qt.qpa.xcb: could not connect to display
    ENV["QT_QPA_PLATFORM"] = "minimal" unless OS.mac?
    cp pkgshare/"examples/exporting/save/save_1.cpp", testpath/"test.cpp"
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lmatplot", "-o", "test"
    system "./test"
    assert_predicate testpath/"img/barchart.svg", :exist?
  end
end
