class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  url "https://github.com/halide/Halide/archive/v12.0.1.tar.gz"
  sha256 "17f7a470c3fcf77205fdcd9d06257f17c1c1a3cda4b8023f56cec160e80bd519"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ed6402f7e024cb534d50751c3eb5aa364bdb396e7c6cd3ad0092de0fdb6aa505"
    sha256 cellar: :any, big_sur:       "dd1c5a0f4d68e58a0c1e3e1d474c9e0c257122d84bb70044d15fc8a93a774bde"
    sha256 cellar: :any, catalina:      "25b4e27297e0e1431564fd032f5b6c674481c7b07a9289f9d2297bfae5e77cde"
    sha256 cellar: :any, mojave:        "1cbb1616fe39338760337bbd84b94ffea6e71db136c3c9013934fad191c1df3e"
  end

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "llvm@12"
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
