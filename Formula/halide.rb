class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  url "https://github.com/halide/Halide/archive/v10.0.0.tar.gz"
  sha256 "23808f8e9746aea25349a16da92e89ae320990df3c315c309789fb209ee40f20"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "061a4d20c6c8772a49b858e9cae542482e4383328ec8baaef0eb4613dc06f398" => :big_sur
    sha256 "8f6e1c100dd2fbabef29fd1ffe9dbb30500c6fc095b38c2c7382ca82eb70e6ac" => :arm64_big_sur
    sha256 "997ed23a3fcb238899272fab8a0f9c2948477fb53bdc1bf2382a31418bc51571" => :catalina
    sha256 "281f9219faf56e6e4b01e44bde6d9e8a4cd8bb0283e14aa6f2f78f6db4301dec" => :mojave
    sha256 "5aaa4023bfff9d9f1f18ee1efae442ff7e0c21c84acc220555504c42705d9c7c" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libomp"
  depends_on "libpng"
  depends_on "llvm"
  depends_on "python@3.9"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
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
