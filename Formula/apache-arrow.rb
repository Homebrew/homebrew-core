class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://github.com/apache/arrow/archive/apache-arrow-0.4.1.tar.gz"
  sha256 "a4fd4aaa3a2f671d031f0c31b4ed72df948d60c1b5aba84188b032da56e409e3"

  head "https://github.com/apache/arrow.git"

  # NOTE: remove ccache with Apache Arrow 0.5 and higher version
  depends_on "ccache" => :recommended
  depends_on "boost"
  depends_on "cmake" => :build

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
    (testpath/"test.cpp").write <<-EOS.undent
    #include "arrow/api.h"
    int main(void)
    {
      arrow::Int64Builder builder(arrow::default_memory_pool(), arrow::int64());
      return 0;
    }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-larrow", "-o", "test"
    system "./test"
  end
end
