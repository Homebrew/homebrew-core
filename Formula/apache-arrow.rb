class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=arrow/arrow-0.7.1/apache-arrow-0.7.1.tar.gz"
  sha256 "f8f114d427a8702791c18a26bdcc9df2a274b8388e08d2d8c73dd09dc08e888e"
  head "https://github.com/apache/arrow.git"

  bottle do
    cellar :any
    sha256 "4afb46a3cc65369fc49b7dd57bbfa097b6a8458aad78232b9ed3f242f7f62cf1" => :high_sierra
    sha256 "2759120287b588d05fb10116d6521d632df7ba297e7ef59ea3ad678085d0304b" => :sierra
    sha256 "5a571f534f97b6ddcd3198aee2c1bcd6cc38e6435debc0d0eb3d9f3b03650779" => :el_capitan
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
