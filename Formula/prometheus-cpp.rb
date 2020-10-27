class PrometheusCpp < Formula
  desc "Prometheus Client Library for Modern C++"
  homepage "https://github.com/jupp0r/prometheus-cpp"
  url "https://github.com/jupp0r/prometheus-cpp.git",
    tag:      "v0.10.0",
    revision: "62897f9e794e9f16471e8a53f367268109e7fa6e",
    shallow:  false
  license "MIT"
  head "https://github.com/jupp0r/prometheus-cpp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd5025a44a31af6dff41e71c3d241b7bdb689e4e97659a8ebce35a7e44dd9860" => :catalina
    sha256 "e9bcb8999fef1b2ef32fd492ac68dedd1776cc5571532e43e4627c38b0b131bd" => :mojave
    sha256 "5b5f45777549c4407be8bbfdc55e5d351ea71c02974d5b61713a39a63d0732d8" => :high_sierra
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <prometheus/Registry.h>
      int main() {
        prometheus::Registry reg;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}", "-lprometheus-cpp-core", "-o", "test"
    system "./test"
  end
end
