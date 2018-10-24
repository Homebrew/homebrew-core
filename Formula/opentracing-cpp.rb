class OpentracingCpp < Formula
  desc "OpenTracing API for C++"
  homepage "https://opentracing.io/"
  url "https://github.com/opentracing/opentracing-cpp/archive/v1.5.0.tar.gz"
  sha256 "4455ca507936bc4b658ded10a90d8ebbbd61c58f06207be565a4ffdc885687b5"

  bottle do
    cellar :any
    sha256 "77e90986d743b410c54ba63a30cf0741eb8f2faa68392a5c726c613c6113695c" => :mojave
    sha256 "e88447ef67b65da415b9c6b747eb38e18a6ef7abc268334bd5b561d825b7eedb" => :high_sierra
    sha256 "5466485c5f18de7452c2d4b043e0dcf0c23f3e0fa9fc93d8d84177b38eae8c34" => :sierra
  end

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
