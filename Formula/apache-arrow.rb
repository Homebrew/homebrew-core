class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-1.0.0/apache-arrow-1.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-1.0.0/apache-arrow-1.0.0.tar.gz"
  sha256 "86ddb9feb48203a5aaf9cc4f2827525e20a2ca4d7239e492af17e74532ccf243"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git"

  bottle do
    cellar :any
    sha256 "f233da1f2e43a5a98f178cdaa6fe371f74255d3fec4943125d7cfaa219cafc40" => :catalina
    sha256 "35fbe889ef3e548a2d55a91d75eb846a72d5fdd408993c1d85e93f354a6e44fb" => :mojave
    sha256 "9af939cc5656770894b4fe2766125584df1fb67487e7000c52c995c1e9067cea" => :high_sierra
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "brotli"
  depends_on "glog"
  depends_on "grpc"
  depends_on "lz4"
  depends_on "numpy"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "python@3.8"
  depends_on "rapidjson"
  depends_on "snappy"
  depends_on "thrift"
  depends_on "zstd"

  def install
    ENV.cxx11
    args = %W[
      -DARROW_FLIGHT=ON
      -DARROW_JEMALLOC=ON
      -DARROW_ORC=ON
      -DARROW_PARQUET=ON
      -DARROW_PLASMA=ON
      -DARROW_PROTOBUF_USE_SHARED=ON
      -DARROW_PYTHON=ON
      -DARROW_WITH_BZ2=ON
      -DARROW_WITH_ZLIB=ON
      -DARROW_WITH_ZSTD=ON
      -DARROW_WITH_LZ4=ON
      -DARROW_WITH_SNAPPY=ON
      -DARROW_WITH_BROTLI=ON
      -DARROW_INSTALL_NAME_RPATH=OFF
      -DPYTHON_EXECUTABLE=#{Formula["python@3.8"].bin/"python3"}
    ]

    mkdir "build"
    cd "build" do
      system "cmake", "../cpp", *std_cmake_args, *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "arrow/api.h"
      int main(void) {
        arrow::int64();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-larrow", "-o", "test"
    system "./test"
  end
end
