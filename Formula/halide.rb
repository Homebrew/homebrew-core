class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  license "MIT"
  revision 4

  # Remove `stable` when we switch to `llvm`.
  stable do
    url "https://github.com/halide/Halide/archive/v14.0.0.tar.gz"
    sha256 "f9fc9765217cbd10e3a3e3883a60fc8f2dbbeaac634b45c789577a8a87999a01"
    depends_on "llvm@14"
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7bf36ad51cb2ec88eb01136b4d5695a4d2a7af42da40150cec324faafbaaeae1"
    sha256 cellar: :any,                 arm64_big_sur:  "43435fafaeb014f4c94b62101bbec01d22466d6382ec5c46e7271aae6c361c22"
    sha256 cellar: :any,                 monterey:       "c619a793848cc7bd3f90035c198b9b1a94a208d3d35eba5b722042d76ca48a12"
    sha256 cellar: :any,                 big_sur:        "f5b0c593a6c59ce386dc841274f58c36a21e9e50d057e79cef95ddef32451cd3"
    sha256 cellar: :any,                 catalina:       "fd4a82463434474fc93da88542700ca015a1451926aecd70144d95e6e36272bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5818e980b9312c1cb29a0cd0ca4991d8ad373fb63d3dff0a36febbd22e4e989a"
  end

  head do
    url "https://github.com/halide/Halide.git", branch: "main"
    depends_on "llvm"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "python@3.10"

  fails_with gcc: "5" # LLVM is built with Homebrew GCC

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DHalide_SHARED_LLVM=ON
      -DPYBIND11_USE_FETCHCONTENT=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    cp share/"doc/Halide/tutorial/lesson_01_basics.cpp", testpath
    system ENV.cxx, "-std=c++17", "lesson_01_basics.cpp", "-L#{lib}", "-lHalide", "-o", "test"
    assert_match "Success!", shell_output("./test")
  end
end
