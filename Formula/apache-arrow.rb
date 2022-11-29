class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-10.0.1/apache-arrow-10.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-10.0.1/apache-arrow-10.0.1.tar.gz"
  sha256 "c814e0670112a22c1a6ec03ab420a52ae236a9a42e9e438c3cbd37f37e658fb3"
  license "Apache-2.0"
  revision 2
  head "https://github.com/apache/arrow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "d13d172c0b31a9ff8b1e9c70d33a1b706d798b1509ef2461e228ab338afed39c"
    sha256 cellar: :any, arm64_monterey: "921dd5b2fc44a8f41e5d330c93ee0b1407c3539def5437e183d853a8b3f6c8a2"
    sha256 cellar: :any, arm64_big_sur:  "e2a0787d1c2da1109c996778b2dac804393c8667dda292589325aeff2abd227e"
    sha256 cellar: :any, ventura:        "05bca50f600809d98400331f6ef7ab11fe0eefe5fa4e00a096aca16b7ff26eef"
    sha256 cellar: :any, monterey:       "0cde42493efb299f5d507770d172b2d1b4f4fbdb67760ac8a60b8ec2bf7d5363"
    sha256 cellar: :any, big_sur:        "02ae77f724266ad55d6d642bd3fba81a555583096b9b6200d629d7384f68b5a6"
    sha256 cellar: :any, catalina:       "fef542aebe98494e0a9b68cc29a7c3a58038760ccb534d3bd3bf634711365295"
    sha256               x86_64_linux:   "1f9b1c8e729c958fdba08b54406fb0ddfba267359e68c5b0e9fd9c953ea815d1"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "llvm" => :build
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
  depends_on "z3"
  depends_on "zstd"

  fails_with gcc: "5"

  def install
    # https://github.com/Homebrew/homebrew-core/issues/76537
    ENV.runtime_cpu_detection if Hardware::CPU.intel?

    args = %W[
      -DCMAKE_FIND_PACKAGE_PREFER_CONFIG=TRUE
      -DCMAKE_INSTALL_RPATH=#{rpath}
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
      -DARROW_PLASMA=ON
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
