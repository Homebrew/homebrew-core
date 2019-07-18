class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=arrow/arrow-0.14.0/apache-arrow-0.14.0.tar.gz"
  sha256 "71e668e1901a06211d3f7ab6b6c7cb80ab1c81bb0d22885be42b74782e953470"
  head "https://github.com/apache/arrow.git"

  bottle do
    cellar :any
    sha256 "316a71df783e9a23bb0e46ad420f242cd08bd03f51a437ff97d7aeedf98af8db" => :mojave
    sha256 "ee55d7d066429c234c09fe68bfa0f6fe722bf1e6bdffc1d570264df9da6ac7ae" => :high_sierra
    sha256 "b54f97234cf844860cd43aae740280e7fb13b1ec8144f180b5d8f756fe6f5600" => :sierra
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
  depends_on "openssl"
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
