class Matplotplusplus < Formula
  desc "C++ Graphics Library for Data Visualization"
  homepage "https://github.com/alandefreitas/matplotplusplus"
  url "https://github.com/alandefreitas/matplotplusplus/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "9dd7cc92b2425148f50329f5a3bf95f9774ac807657838972d35334b5ff7cb87"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c32ca572fd775cc0659be1314e06047f9d9f245e02d3c43ad4500ac84a9a7290"
    sha256 cellar: :any,                 arm64_ventura:  "4882c11bd408f3e4532558b98f76b831775bb154a9645c8cf7f6d2d72295e1fa"
    sha256 cellar: :any,                 arm64_monterey: "faf64ded9d8bd33a4992f4e17266c98ccb0299944135afcab9996423c1768068"
    sha256 cellar: :any,                 sonoma:         "093db12d6f31223aec6dc8624cb1d4034739ebf62b74c188a42d252df7087dbb"
    sha256 cellar: :any,                 ventura:        "2912de97be2ee340f216877e8f3660ceebd7b3e6d0c603784bd764b409e44e83"
    sha256 cellar: :any,                 monterey:       "23fa45235767c6d820822eefcdcba209ae48ad175b7261f4c1d244fb08cbc7c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dff586197efba0a30a6bfd7d7ea51712e6b34d430efc9d6e512b7f65e8306124"
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
