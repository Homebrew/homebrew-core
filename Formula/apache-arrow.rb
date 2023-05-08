class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-12.0.0/apache-arrow-12.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-12.0.0/apache-arrow-12.0.0.tar.gz"
  sha256 "ddd8347882775e53af7d0965a1902b7d8fcd0a030fd14f783d4f85e821352d52"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "06b36477eb25d47f58296d3d00754c2025f67e7b1da1a9673a0febc939ab21c9"
    sha256 cellar: :any, arm64_monterey: "96aef5732ff86467cdfacf3b66d6b8d0b3412f7b9499cb928accdd75e975544b"
    sha256 cellar: :any, arm64_big_sur:  "c01884742161c162f855194560e893de4ff00fe25a7ea9c63f1026c581eebe28"
    sha256 cellar: :any, ventura:        "bd23809237af9dee7f93e1360a14457dc144362cc4e4dd9abe0b8d968e2a7fd3"
    sha256 cellar: :any, monterey:       "0204082a92c98a1959b1ee877633eb7d91fb6c66c7021623eb2ae738808dad70"
    sha256 cellar: :any, big_sur:        "bea0b5461b74e1ffa5974d4da9902b59ed4f4f802e55245fb342c848493ed653"
    sha256               x86_64_linux:   "d64c0672b094200d9cbc3a43fc2581fd7e181ce509757074bcb6c93671d49bd8"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "llvm@15" => :build
  depends_on "aws-sdk-cpp"
  depends_on "brotli"
  depends_on "bzip2"
  depends_on "glog"
  depends_on "grpc"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "rapidjson"
  depends_on "re2"
  depends_on "snappy"
  depends_on "thrift"
  depends_on "utf8proc"
  depends_on "zstd"
  uses_from_macos "python" => :build

  fails_with gcc: "5"

  def install
    # https://github.com/Homebrew/homebrew-core/issues/76537
    ENV.runtime_cpu_detection if Hardware::CPU.intel?

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DARROW_ACERO=ON
      -DARROW_COMPUTE=ON
      -DARROW_CSV=ON
      -DARROW_DATASET=ON
      -DARROW_FILESYSTEM=ON
      -DARROW_FLIGHT=ON
      -DARROW_FLIGHT_SQL=ON
      -DARROW_GANDIVA=ON
      -DARROW_HDFS=ON
      -DARROW_JSON=ON
      -DARROW_ORC=ON
      -DARROW_PARQUET=ON
      -DARROW_PROTOBUF_USE_SHARED=ON
      -DARROW_S3=ON
      -DARROW_WITH_BZ2=ON
      -DARROW_WITH_ZLIB=ON
      -DARROW_WITH_ZSTD=ON
      -DARROW_WITH_LZ4=ON
      -DARROW_WITH_SNAPPY=ON
      -DARROW_WITH_BROTLI=ON
      -DARROW_WITH_UTF8PROC=ON
      -DARROW_INSTALL_NAME_RPATH=OFF
    ]

    args << "-DARROW_MIMALLOC=ON" unless Hardware::CPU.arm?

    system "cmake", "-S", "cpp", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "arrow/api.h"
      int main(void) {
        arrow::int64();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-larrow", "-o", "test"
    system "./test"
  end
end
