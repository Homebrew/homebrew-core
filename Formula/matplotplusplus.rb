class Matplotplusplus < Formula
  desc "C++ Graphics Library for Data Visualization"
  homepage "https://github.com/alandefreitas/matplotplusplus"
  url "https://github.com/alandefreitas/matplotplusplus/archive/v1.1.0.tar.gz"
  sha256 "5c3a1bdfee12f5c11fd194361040fe4760f57e334523ac125ec22b2cb03f27bb"
  license "MIT"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "09f1065112d8fab2b6b7a4505de70b8e8f72cf3f165bfb779b4e5aa0bd6b75cb"
    sha256 cellar: :any,                 arm64_monterey: "bf944af3d150c4d06d0d5ba4c4005a36c263fa4ff63d0b6048612970bab99b39"
    sha256 cellar: :any,                 arm64_big_sur:  "49ed10a408488bc95f3d3efddd435ef858b910b046f36615461db38efd3a04c4"
    sha256 cellar: :any,                 ventura:        "a04c9052fd35660c346bcf9d122eac5378d63f97b4fcb8846921b36fdd46225f"
    sha256 cellar: :any,                 monterey:       "3325d540aad16f1d48eddbe316a95f7bbe0948e36644dbd3839d25df5d647ef4"
    sha256 cellar: :any,                 big_sur:        "b57950328175d4dbfd5c46c5f2e587227d11d5031f06eb3a31df781d425570d3"
    sha256 cellar: :any,                 catalina:       "a0830f3c946d045384f6b91511688baafc0ea91b3e1e7f34f4c6c10173179efe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7231dfcdab4f21ff3fa9303b76a4b9b1a820a3d8debf54ac1607fc190071dd7"
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
