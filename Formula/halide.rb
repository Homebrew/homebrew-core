class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  url "https://github.com/halide/Halide/archive/v14.0.0.tar.gz"
  sha256 "f9fc9765217cbd10e3a3e3883a60fc8f2dbbeaac634b45c789577a8a87999a01"
  license "MIT"
  revision 2
  head "https://github.com/halide/Halide.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a0f08ad604bf0bce564b59dcc8834465ac394de21df82ba8bc2a5a8945ad1c14"
    sha256 cellar: :any,                 arm64_big_sur:  "731f4579b98a53937dfa926d7ed743486a21623f63b999a9388bf03ca2b07dba"
    sha256 cellar: :any,                 monterey:       "dccc07728f57b7ce390d3370a4f262c5e0dc0784a5ab61dca69f102c7a7f0a77"
    sha256 cellar: :any,                 big_sur:        "70a1fad1c68157715403b5ace8a5a18812a69e4e9c50ab6152dfe3e06609cfde"
    sha256 cellar: :any,                 catalina:       "b73bcf60ebb46fa3cc8b6caa7a60a4e666b20be11e93575cf1950da7f6b6e879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ffb43bc29d58a381f39f4a9760a3cfdf544ce514add06ed6545e7fa0d8ca84d"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "llvm"
  depends_on "python@3.10"

  fails_with gcc: "5" # LLVM is built with Homebrew GCC

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DHalide_SHARED_LLVM=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    cp share/"doc/Halide/tutorial/lesson_01_basics.cpp", testpath
    system ENV.cxx, "-std=c++17", "lesson_01_basics.cpp", "-L#{lib}", "-lHalide", "-o", "test"
    assert_match "Success!", shell_output("./test")
  end
end
