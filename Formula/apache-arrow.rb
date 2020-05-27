class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-0.17.1/apache-arrow-0.17.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-0.17.1/apache-arrow-0.17.1.tar.gz"
  sha256 "cbc51c343bca08b10f7f1b2ef15cb15057c30e5e9017cfcee18337b7e2da9ea2"
  revision 1
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
      -DARROW_JEMALLOC=OFF
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
