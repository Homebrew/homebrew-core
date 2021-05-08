class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-4.0.0/apache-arrow-4.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-4.0.0/apache-arrow-4.0.0.tar.gz"
  sha256 "4a31d0bf702e953bdbcda67af10762a33308281bd247fcbd152ee177419649ae"
  license "Apache-2.0"
  revision 2
  head "https://github.com/apache/arrow.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a404fde9ca54f797e7452fedf31283e9983e2e9ade687d82ff4c642f75173ddd"
    sha256 cellar: :any, big_sur:       "cd79491a2538c95c9668a8b85cb97291b9450700618e767b94a4f988b7c89809"
    sha256 cellar: :any, catalina:      "2cb7fd71e05cb2dba2316c91691cc47ff9ab294e4eb3d884935c073eb9cf05ac"
    sha256 cellar: :any, mojave:        "a039fb7f7c94dedfd1281adf0848bc673f8f213c5da48a1d9114757cc8fdb3ae"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "llvm" => :build
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
    # link against system libc++ instead of llvm provided libc++
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
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

    args << "-DARROW_MIMALLOC=ON" unless Hardware::CPU.arm?

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
