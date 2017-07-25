class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=arrow/arrow-0.5.0/apache-arrow-0.5.0.tar.gz"
  sha256 "007a84294091324567bcfd826460e49fd98641c681828e77b79d62261d842bd7"

  head "https://github.com/apache/arrow.git"

  bottle do
    cellar :any
    sha256 "12cf3b8b04c5c84b81a20017ff3df29577dcb470d4998a542ec13b6b0d9eda8a" => :sierra
    sha256 "181f54ef1b1c21fa23492b3b0ac7d24960ab1c508611c07e9c63429201faf0bb" => :el_capitan
    sha256 "c4177126e46fea32614aae23e9d21f03334d75f8afd1940511931c3e70a3c67e" => :yosemite
  end

  # NOTE: remove ccache with Apache Arrow 0.5 and higher version
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "jemalloc"
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
