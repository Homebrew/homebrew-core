class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-11.0.0/apache-arrow-11.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-11.0.0/apache-arrow-11.0.0.tar.gz"
  sha256 "2dd8f0ea0848a58785628ee3a57675548d509e17213a2f5d72b0d900b43f5430"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/arrow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "3f886898424c4d69047f4e75ea418c13eeabbddb1e8d6d7272981b57d7992aa9"
    sha256 cellar: :any, arm64_monterey: "4fb530fefbc703ab3532546fde0740a48836f96acc2b9015a5398134a6fb3b62"
    sha256 cellar: :any, arm64_big_sur:  "a1a418875a5603a971279c707dca386dee46da44d8ee1bd8a0d3e750ef92ec3f"
    sha256 cellar: :any, ventura:        "972b67b08cf62ef783e7e703d87d9ed24f7677186e0b028c98c91afefc193b5e"
    sha256 cellar: :any, monterey:       "92ac01e8d63c0150a0532b5887c2ed0f01adf915ce8bfed985064a6b1c1b5ad4"
    sha256 cellar: :any, big_sur:        "5c843736daa03fce8a9509204f4c9f63e403fb39e5908607c95763032bc79c65"
    sha256               x86_64_linux:   "8af56df47735d2191f68e9953d474593f82bed6b868676703ad79b0fac26102d"
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
