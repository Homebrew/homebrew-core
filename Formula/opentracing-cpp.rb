class OpentracingCpp < Formula
  desc "OpenTracing API for C++"
  homepage "http://opentracing.io"
  url "https://github.com/opentracing/opentracing-cpp/archive/v1.5.0.tar.gz"
  sha256 "4455ca507936bc4b658ded10a90d8ebbbd61c58f06207be565a4ffdc885687b5"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    pkgshare.install "example/tutorial/tutorial-example.cpp"
    pkgshare.install "example/tutorial/text_map_carrier.h"
  end

  test do
    system ENV.cxx, "#{pkgshare}/tutorial-example.cpp", "-std=c++11", "-L#{lib}", "-I#{include}", "-lopentracing", "-lopentracing_mocktracer", "-o", "tutorial-example"
    system "./tutorial-example"
  end
end
