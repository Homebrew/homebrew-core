class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  url "https://github.com/halide/Halide/archive/v11.0.0.tar.gz"
  sha256 "381f6b586333cb9279ca9fe5d93cb11d4603e7e9832061204f57c5535f8225f0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8f6e1c100dd2fbabef29fd1ffe9dbb30500c6fc095b38c2c7382ca82eb70e6ac"
    sha256 cellar: :any, big_sur:       "061a4d20c6c8772a49b858e9cae542482e4383328ec8baaef0eb4613dc06f398"
    sha256 cellar: :any, catalina:      "997ed23a3fcb238899272fab8a0f9c2948477fb53bdc1bf2382a31418bc51571"
    sha256 cellar: :any, mojave:        "281f9219faf56e6e4b01e44bde6d9e8a4cd8bb0283e14aa6f2f78f6db4301dec"
    sha256 cellar: :any, high_sierra:   "5aaa4023bfff9d9f1f18ee1efae442ff7e0c21c84acc220555504c42705d9c7c"
  end

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libomp"
  depends_on "libpng"
  depends_on "llvm"
  depends_on "python@3.9"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DHalide_SHARED_LLVM=ON"
      system "make"
      system "make", "install"
    end
  end

  test do
    cp share/"tutorial/lesson_01_basics.cpp", testpath
    system ENV.cxx, "-std=c++11", "lesson_01_basics.cpp", "-L#{lib}", "-lHalide", "-o", "test"
    assert_match "Success!", shell_output("./test")
  end
end
