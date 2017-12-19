class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=arrow/arrow-0.8.0/apache-arrow-0.8.0.tar.gz"
  sha256 "b142b883c7107485a296655e8d7421d11891acbca15862f37a4a8c1b13d4e9c4"
  head "https://github.com/apache/arrow.git"

  bottle do
    cellar :any
    sha256 "cf14b21dba18ec0a9bafa2a2e7447aae2e317412b37b24bcc40cf6fc6cc53852" => :high_sierra
    sha256 "6a9dba93b7552698422e8db73e6b16e59f4dc2f8a8f3dc1231d62a0827cd7488" => :sierra
    sha256 "2571635787d41ec3930506e7d47f8e52b94dd7ad3c1f6770e6690e803cbda4c0" => :el_capitan
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
