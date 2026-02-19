class Matplotplusplus < Formula
  desc "C++ Graphics Library for Data Visualization"
  homepage "https://github.com/alandefreitas/matplotplusplus"
  url "https://github.com/alandefreitas/matplotplusplus/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "c7434b4fea0d0cc3508fd7104fafbb2fa7c824b1d2ccc51c52eaee26fc55a9a0"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "12afe3a93bd74cc8c1039cfe96eec69e9ad490de007b89dd2dee691848fc4a94"
    sha256 cellar: :any,                 arm64_sequoia: "b5c2fff54b01a15975ab60daf1b38908c0bd5772be34b07417e4e3e55c8d500e"
    sha256 cellar: :any,                 arm64_sonoma:  "7c5bbc02ddef5de8311d9635b53c8abb40fea9619beffe32b656a9e3aff9b06e"
    sha256 cellar: :any,                 sonoma:        "ef278a8c8acbad0e5cb1984fc4eae897beb79d698552ef7f1d051679305448e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b53553604ff956b056570d08fa562c43cd7f5d54160ad02bf654dbb03807dcec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4221d3f2856320db0988a6661bdf045fd82b62145fc51b46e87e822752249eb3"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "fftw"
  depends_on "gnuplot"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openexr"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
