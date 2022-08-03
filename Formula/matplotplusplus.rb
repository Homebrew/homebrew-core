class Matplotplusplus < Formula
  desc "C++ Graphics Library for Data Visualization"
  homepage "https://github.com/alandefreitas/matplotplusplus"
  url "https://github.com/alandefreitas/matplotplusplus/archive/v1.1.0.tar.gz"
  sha256 "5c3a1bdfee12f5c11fd194361040fe4760f57e334523ac125ec22b2cb03f27bb"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8aaf3ce03497736d24787a13a9cbc5a3163b460d9c3548d41cf9b859ec0249e1"
    sha256 cellar: :any,                 arm64_big_sur:  "3251e1e749e26b89b4c243f4a2e407d6fe5e2b7f7ede4ab155f1e1067c11eb48"
    sha256 cellar: :any,                 monterey:       "123a426f1c272a1c5b19877bda0bd96166d17184220f9ae63c9a78c4a565d3fb"
    sha256 cellar: :any,                 big_sur:        "26729c7dd02fea563576e384d3d16df8bf20d696a72613bec4275ba7291d5c3e"
    sha256 cellar: :any,                 catalina:       "cd9b3e14a51da8d19a76c2d226586b92c620e200881ef8dddd855085b3ebcb17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c06e417fe11ad807aa29b848435bca497d7091b611dd5a9467520fc5c63078b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "gnuplot"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openexr"

  on_linux do
    depends_on "gcc"
  end

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
