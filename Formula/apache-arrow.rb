class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-0.17.0/apache-arrow-0.17.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-0.17.0/apache-arrow-0.17.0.tar.gz"
  sha256 "2c46b4c3e1f88aad510214e633a6f4ce459708f3db78cd0daf549a135cbe8e6d"
  head "https://github.com/apache/arrow.git"

  bottle do
    cellar :any
    sha256 "c20eed2cd9e5c4f123086f9926598d674fa26579d9e87a019ef7d35d583719cc" => :catalina
    sha256 "fa2827d1df83272fa9809dedb4260e79e1e4af827f8bcf0cbf39b51ebcbe1377" => :mojave
    sha256 "b8f0b32f2da88189410c9588a9fbd44488477e087d71a92373c99e729318f3dc" => :high_sierra
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
