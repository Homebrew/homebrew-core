class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=arrow/arrow-0.4.1/apache-arrow-0.4.1.tar.gz"
  sha256 "499401661f9c768ba7e8a27f02a2079efc207628d7fd856cf03aa301f5dc9986"

  head "https://github.com/apache/arrow.git"

  bottle do
    cellar :any
    sha256 "4baf8d8e346d82f8babed57ec2097843297d62222dc61d8c9c7359b58906f6cc" => :sierra
    sha256 "cc4fcc810cf56d16285bf7084a704b0ccf51906149c416423b92c24889c460d4" => :el_capitan
    sha256 "85ae6ec3bec5d9c9796a8d1dd87c7af8e6301d282c8327a58385519eda0c4214" => :yosemite
  end

  # NOTE: remove ccache with Apache Arrow 0.5 and higher version
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "ccache" => :recommended

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
