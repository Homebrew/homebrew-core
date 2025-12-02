class Matplotplusplus < Formula
  desc "C++ Graphics Library for Data Visualization"
  homepage "https://github.com/alandefreitas/matplotplusplus"
  url "https://github.com/alandefreitas/matplotplusplus/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "c7434b4fea0d0cc3508fd7104fafbb2fa7c824b1d2ccc51c52eaee26fc55a9a0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2b9397c694c7707a80feb995232954d614d4d8a8372b58d99ddb4d82dcca511e"
    sha256 cellar: :any,                 arm64_sequoia: "e2ba675ac81348b5f335837aff0f31d76e9786cb863f1e7e78310dc866b0fd8a"
    sha256 cellar: :any,                 arm64_sonoma:  "19c28227de5d694cef734a453ae5a5fa9235100178c330a89e0bf69b1152c9c3"
    sha256 cellar: :any,                 arm64_ventura: "a6ea197fbc598aea232a2a2ee3f34a49d901fe7bcb5ef1669fad420bc9761df9"
    sha256 cellar: :any,                 sonoma:        "fd6ad4314564c49faa1c3a579059e691bd42ad7bc806bfdd9b6da50de1493136"
    sha256 cellar: :any,                 ventura:       "1629d3f81ffeea448e2a23ce724c64108e4b98d28fff1c94c9caf42aad066fd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16d52a3f9fe266742220680c9634012ae28f593c6c59379a707cce29fc90ea94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b326b9d0868c29fc1ca8749f38f40b7941baddf059b9342a15f64c8dab70ad1"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
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

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DBUILD_EXAMPLES=OFF",
                    *std_cmake_args
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
    assert_path_exists testpath/"img/barchart.svg"
  end
end
