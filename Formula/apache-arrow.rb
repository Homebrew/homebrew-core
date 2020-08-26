class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-1.0.1/apache-arrow-1.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-1.0.1/apache-arrow-1.0.1.tar.gz"
  sha256 "149ca6aa969ac5742f3b30d1f69a6931a533fd1db8b96712e60bf386a26dc75c"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git"

  bottle do
    cellar :any
    sha256 "02de039dba50f1d877fc1a1985556c6dc567e394c70b81792984b811056592f6" => :catalina
    sha256 "3b182187486e7df8b750bac60c08b5a74f10394e2e82c2dce824a95d93f8e847" => :mojave
    sha256 "006e8ade39d21f9da3cd4b52c83ad4458df52fe74d405d5d696c8075036cadc2" => :high_sierra
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "llvm"  => :build
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

  # Fix to not install jemalloc in parallel
  # https://github.com/apache/arrow/pull/7995
  patch do
    url "https://github.com/apache/arrow/commit/ae60bad1c2e28bd67cdaeaa05f35096ae193e43a.patch?full_index=1"
    sha256 "7a793ca3c98a803c652757faa802667e6d19dbc436cedb942c76346771c9e16f"
  end

  def install
    ENV.cxx11
    # link against system libc++ instead of llvm provided libc++
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
    args = %W[
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
