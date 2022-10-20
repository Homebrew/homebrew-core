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
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "e697bf5bed9b11384f96f743938d543115f9818c8ea06b1b432b1ff191e39cbe"
    sha256 cellar: :any,                 arm64_big_sur:  "d7690245f152177b5c7c18d3ef1a463926d8f973de234c4c0ea7eea170075600"
    sha256 cellar: :any,                 monterey:       "3ae454537e4046dcb986a4f479abeb3cca193f18ec494846f3fd46c338f2ba52"
    sha256 cellar: :any,                 big_sur:        "5906516e5e68a90112cf56c16a80fcaaa0b88b29e8e79684ae7d42695c22e5c5"
    sha256 cellar: :any,                 catalina:       "13ab625f06ccb12567c9b99f2150c2166e87ea2999955693c022443b4339c108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e03ed9df8d6ef2324933bb3bd23fad889489b29e78c6f7a23f3a841e0d32285e"
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
