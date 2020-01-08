class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=arrow/arrow-0.15.1/apache-arrow-0.15.1.tar.gz"
  sha256 "9a2c58c72310eafebb4997244cbeeb8c26696320d0ae3eb3e8512f75ef856fc9"
  revision 3
  head "https://github.com/apache/arrow.git"

  bottle do
    cellar :any
    sha256 "51c5df916c795016199c9ccb96970cc6f7f2c5a2382aff716f106fd22e9ffe1a" => :catalina
    sha256 "378e4e77e56c549db1676ed865b02ac18b2e03f68d2205b46af4b6ff243b2d48" => :mojave
    sha256 "dc8780d6c8ad035d830c70917e4be9830aa01fc88b4a4a90cb07136bbaac56d2" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "brotli"
  depends_on "double-conversion"
  depends_on "flatbuffers"
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
      -DARROW_ORC=ON
      -DARROW_PARQUET=ON
      -DARROW_PLASMA=ON
      -DARROW_PROTOBUF_USE_SHARED=ON
      -DARROW_PYTHON=ON
      -DARROW_JEMALLOC=OFF
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
