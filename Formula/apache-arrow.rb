class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-2.0.0/apache-arrow-2.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-2.0.0/apache-arrow-2.0.0.tar.gz"
  sha256 "be0342cc847bb340d86aeaef43596a0b6c1dbf1ede9c789a503d939e01c71fbe"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/arrow.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "c4eacba6faeac0c43dbda3deb7dcc165e8cdecc6050de0286bbf94ebdb60ed71" => :big_sur
    sha256 "524086a1fafea08afae498b587c52a6171ce5a862d3ced4fa70857e9c2a95693" => :catalina
    sha256 "cb2fd7de62c49aae81e001955384016b6d5b3e50daee25add17a1575bff04782" => :mojave
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "llvm@9" => :build
  depends_on "brotli"
  depends_on "glog"
  depends_on "grpc"
  depends_on "lz4"
  depends_on "numpy"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "python@3.9"
  depends_on "rapidjson"
  depends_on "re2"
  depends_on "snappy"
  depends_on "thrift"
  depends_on "zstd"

  def install
    ENV.cxx11
    # link against system libc++ instead of llvm provided libc++
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm@9"].opt_lib
    args = %W[
      -DCMAKE_FIND_PACKAGE_PREFER_CONFIG=TRUE
      -DARROW_FLIGHT=ON
      -DARROW_GANDIVA=ON
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
      -DPYTHON_EXECUTABLE=#{Formula["python@3.9"].bin/"python3"}
    ]

    mkdir "build" do
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
