class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  url "https://github.com/halide/Halide/archive/v12.0.1.tar.gz"
  sha256 "17f7a470c3fcf77205fdcd9d06257f17c1c1a3cda4b8023f56cec160e80bd519"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ec06dadfe4b28c1d65c927238ee746535891d10f253892b9ad58dc2e2025bdad"
    sha256 cellar: :any, big_sur:       "449658363ecf1bdf3a665e2da22bdfdf11924303b39c32b89db72e7ae0ffc493"
    sha256 cellar: :any, catalina:      "b3ef63e3874c07afecfb6f37754b70cccc59249284d1468c3536eb9ae9e2854d"
    sha256 cellar: :any, mojave:        "4fd8d951abaf4b333f90710673ead7d8fc3c81f1f8d179cb6864d2a29353f25f"
  end

  depends_on "cmake" => :build
  depends_on "jpeg"
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
