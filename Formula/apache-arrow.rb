class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=arrow/arrow-0.9.0/apache-arrow-0.9.0.tar.gz"
  sha256 "beb1c684b2f7737f64407a7b19eb7a12061eec8de3b06ef6e8af95d5a30b899a"
  head "https://github.com/apache/arrow.git"

  bottle do
    cellar :any
    sha256 "1ae82834e4ea5e8f21df420c767a2c864b826c8bd0cd82a1132cfd34c2f55a33" => :high_sierra
    sha256 "be0969900ccf82050684deb5c04458a653e67ed5961b75b62656efa11c99c546" => :sierra
    sha256 "1eca30eb377a3b63dee7e72717c7d3c3a1303be677cf6736ecdc4ddb87b55796" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "jemalloc"

  needs :cxx11

  def install
    ENV.cxx11

    cd "cpp" do
      system "cmake", ".", *std_cmake_args
      system "make", "unittest"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "arrow/api.h"
      int main(void)
      {
        arrow::int64();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-larrow", "-o", "test"
    system "./test"
  end
end
