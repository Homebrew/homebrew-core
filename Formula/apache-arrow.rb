class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-0.16.0/apache-arrow-0.16.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-0.16.0/apache-arrow-0.16.0.tar.gz"
  sha256 "261992de4029a1593195ff4000501503bd403146471b3168bd2cc414ad0fb7f5"
  head "https://github.com/apache/arrow.git"

  bottle do
    cellar :any
    sha256 "d523f37a5332bd67dfbb7517d30c5bcf762c96c0157425d966628616de961317" => :catalina
    sha256 "9a1a351efcec6de325196c7692e03637efcd3557f8b0fc8847e0bb2af7b586c4" => :mojave
    sha256 "b3b2e0681cff1188e6da5bc741a173740a218c1fde467379345a7dd6501b010c" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "brotli"
  depends_on "glog"
  depends_on "grpc"
  depends_on "lz4"
  depends_on "numpy"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "python"
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
      -DPYTHON_EXECUTABLE=#{Formula["python"].bin/"python3"}
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
