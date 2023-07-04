class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-12.0.1/apache-arrow-12.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-12.0.1/apache-arrow-12.0.1.tar.gz"
  sha256 "3481c411393aa15c75e88d93cf8315faf7f43e180fe0790128d3840d417de858"
  license "Apache-2.0"
  revision 2
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "a9a3b844e6bc92e02ac6028fc967603906ebd07c88b46a82ed4b4650a56e529c"
    sha256 cellar: :any, arm64_monterey: "b0a0d2d6c325fdf9ef4f148aa404c2ec363e5c1d3b26849d3b4199d38802cda3"
    sha256 cellar: :any, arm64_big_sur:  "1ed057c053898101a66de280b74ce23422afbbe4bbefbe8371d7dac73901deb5"
    sha256 cellar: :any, ventura:        "6acbfcb2569de245a2576ea5ceb67d66e61f0281d28f44f709480717bab9cc32"
    sha256 cellar: :any, monterey:       "ba22026ae5fde3f2dcba50fb95105923482c6630c904b626515563ee78fc1da8"
    sha256 cellar: :any, big_sur:        "79d2c570db4071d7cc54521d6980ecf0d930a06d3a9e96a7b0cb3f0e3e5ed4ff"
    sha256               x86_64_linux:   "dc9b43300990b56d5fb50962726ca3fada71c0496f16feb6eb7cf8583e66e712"
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
  depends_on "openssl@3"
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
