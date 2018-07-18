class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=arrow/arrow-0.9.0/apache-arrow-0.9.0.tar.gz"
  sha256 "beb1c684b2f7737f64407a7b19eb7a12061eec8de3b06ef6e8af95d5a30b899a"
  revision 1
  head "https://github.com/apache/arrow.git"

  bottle do
    cellar :any
    sha256 "ad46f2697053ace2da654ee4752d022f29e1de12d0f4627c12e1c44b9c911334" => :high_sierra
    sha256 "5fb9d7f3e9ba08ec3f39e36f1f264ace354fcc521b1527eddb930102d24a14ca" => :sierra
    sha256 "156b4d5aaa71240da5707376fd4d8f61f9a39f21756dafdadf6180257f9d593f" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "jemalloc"

  needs :cxx11

  # Arrow build error with the latest clang-10 https://github.com/apache/arrow/issues/2105
  # Will be fixed in next release.
  patch do
    url "https://github.com/apache/arrow/pull/2106.patch?full_index=1"
    sha256 "545a733304e1f9e62b70b6e9c8dc9cae5b33f7b9c32e1df8d47a375d66296ae6"
  end

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
