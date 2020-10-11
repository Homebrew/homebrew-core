class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  url "https://github.com/halide/Halide/archive/v10.0.0.tar.gz"
  sha256 "23808f8e9746aea25349a16da92e89ae320990df3c315c309789fb209ee40f20"
  license "MIT"
  revision 1

  bottle do
    cellar :any
    sha256 "93c86ba497d66ddd04bb5fc29ed122f9388f6911fcbc5d5b9972869a9cdd1bc6" => :catalina
    sha256 "d9db4f376d1aec822e9302540670c7853b8163caf0b824afb6beb33d53549740" => :mojave
    sha256 "34f379eb801990b3c43011befab88deb8507df0d8d9c4b015e5c84c04394f64e" => :high_sierra
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
