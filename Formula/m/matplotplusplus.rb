class Matplotplusplus < Formula
  desc "C++ Graphics Library for Data Visualization"
  homepage "https://github.com/alandefreitas/matplotplusplus"
  url "https://github.com/alandefreitas/matplotplusplus/archive/v1.2.0.tar.gz"
  sha256 "42e24edf717741fcc721242aaa1fdb44e510fbdce4032cdb101c2258761b2554"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fa2119f2c9456048f44ece2fbf02a0ccc8e256c3348b23f4ea1a572662ec4813"
    sha256 cellar: :any,                 arm64_ventura:  "9303a47d6e17b4718fe5536549035dc343c5d62a1545736b9828f221ee0c6a96"
    sha256 cellar: :any,                 arm64_monterey: "bb569ce1db39420566b77fb8ff0cd62808ee3213d9634dce7fbcd58afb77acc6"
    sha256 cellar: :any,                 arm64_big_sur:  "be4bfef96282be1c1e1f527237d15917ff10437edbf98f8bed0a105c58f572d2"
    sha256 cellar: :any,                 sonoma:         "950c691766b1667358b9fce0d6ebb8453c6558607373b50e4e7475ed13c816d4"
    sha256 cellar: :any,                 ventura:        "89a762d1e032a41a5f5cc8ffb18752c5d00baa0c2a0ea3f0273cb74f5971daff"
    sha256 cellar: :any,                 monterey:       "c06d3057a3b371ea6887c008d55afb848b48f0df2f8cf4206b8e7a77b8bfc77e"
    sha256 cellar: :any,                 big_sur:        "4b229eaec3f93b4b872f7f65785c8b717beb31c83c07498798a64f4b1bd9a90d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f24a36084507d7323bcebfde558746baa92f4508ecd5d5729046a04e079b9e2"
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
