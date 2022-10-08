class Iir1 < Formula
  desc "DSP IIR realtime filter library written in C++"
  homepage "https://berndporr.github.io/iir1/"
  url "https://github.com/berndporr/iir1/archive/refs/tags/1.9.3.tar.gz"
  sha256 "de241ef7a3e5ae8e1309846fe820a2e18978aa3df3922bd83c2d75a0fcf4e78f"
  license "MIT"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"test").install "test/butterworth.cpp", "test/assert_print.h"
  end

  test do
    cp (pkgshare/"test").children, testpath
    system ENV.cxx, "-std=c++11", "butterworth.cpp", "-o", "test", "-L#{lib}", "-liir"
    system "./test"
  end
end
