class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-1.0.1/apache-arrow-1.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-1.0.1/apache-arrow-1.0.1.tar.gz"
  sha256 "149ca6aa969ac5742f3b30d1f69a6931a533fd1db8b96712e60bf386a26dc75c"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    rebuild 2
    sha256 "d6989006cc4cbfd1440e37b10953539ac31d3e6545570afef8d919d742e605f3" => :catalina
    sha256 "cbd0ad01c6d8cd50b159c6f01207971b3fc437a510416fa7253bd1f2776054a8" => :mojave
    sha256 "e10b6e6b62a241e2084b18840f8e9f9926130d740cf049346e66653d30d3e8f6" => :high_sierra
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
  depends_on "python@3.8"
  depends_on "rapidjson"
  depends_on "re2"
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
      -DPYTHON_EXECUTABLE=#{Formula["python@3.8"].bin/"python3"}
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
