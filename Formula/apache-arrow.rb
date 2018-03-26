class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=arrow/arrow-0.9.0/apache-arrow-0.9.0.tar.gz"
  sha256 "beb1c684b2f7737f64407a7b19eb7a12061eec8de3b06ef6e8af95d5a30b899a"
  head "https://github.com/apache/arrow.git"

  bottle do
    cellar :any
    sha256 "d9b331ee4ebff205e029854c76e41dea5dbc57dfdc98626c1b557ae434840804" => :high_sierra
    sha256 "c43c8f8198daad4b9580ddd0fc33beda3eac94374a075611f9dd834234e677e6" => :sierra
    sha256 "64d0e868864c37293a454052420d3203d4e689d4be5a4e6b2892a5a6aac6fd3a" => :el_capitan
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
