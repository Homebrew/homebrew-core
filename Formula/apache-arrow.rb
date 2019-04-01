class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=arrow/arrow-0.13.0/apache-arrow-0.13.0.tar.gz"
  sha256 "ac2a77dd9168e9892e432c474611e86ded0be6dfe15f689c948751d37f81391a"
  head "https://github.com/apache/arrow.git"

  bottle do
    cellar :any
    sha256 "f5deaf661c0335231b1ed403ac4f631a1bf0aa1022f931dd2a53e8ecda145b33" => :mojave
    sha256 "6427e625541109cb742adc2f85497dd5f06063f457eef0e2755e53bd5a7e6fce" => :high_sierra
    sha256 "c9778fa603419a516552832dcd71fcf83aedd28c0dc33357e60c40d4434c0ce9" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "flatbuffers"
  depends_on "lz4"
  depends_on "numpy"
  depends_on "protobuf"
  depends_on "python"
  depends_on "snappy"
  depends_on "thrift"
  depends_on "zstd"

  def install
    ENV.cxx11
    args = %W[
      -DARROW_ORC=ON
      -DARROW_PARQUET=ON
      -DARROW_PLASMA=ON
      -DARROW_PROTOBUF_USE_SHARED=ON
      -DARROW_PYTHON=ON
      -DFLATBUFFERS_HOME=#{Formula["flatbuffers"].prefix}
      -DLZ4_HOME=#{Formula["lz4"].prefix}
      -DPROTOBUF_HOME=#{Formula["protobuf"].prefix}
      -DPYTHON_EXECUTABLE=#{Formula["python"].bin/"python3"}
      -DSNAPPY_HOME=#{Formula["snappy"].prefix}
      -DTHRIFT_HOME=#{Formula["thrift"].prefix}
      -DZSTD_HOME=#{Formula["zstd"].prefix}
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
