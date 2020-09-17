class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  url "https://github.com/halide/Halide/archive/v10.0.0.tar.gz"
  sha256 "23808f8e9746aea25349a16da92e89ae320990df3c315c309789fb209ee40f20"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libomp"
  depends_on "libpng"
  depends_on "llvm"
  depends_on "python@3.8"

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
