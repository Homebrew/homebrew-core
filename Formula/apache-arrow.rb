class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-10.0.0/apache-arrow-10.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-10.0.0/apache-arrow-10.0.0.tar.gz"
  sha256 "5b46fa4c54f53e5df0019fe0f9d421e93fc906b625ebe8e89eed010d561f1f12"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "eeb0ad843950a3e641259a9f35aa6317eb55b18a4bb1575d4b9d8626c534a1c2"
    sha256 cellar: :any, arm64_monterey: "01aef3fc9a17f811e16050dfb1813d3af10cf49b30d00bc6c18eed136c10339a"
    sha256 cellar: :any, arm64_big_sur:  "5e98ca18c31d48d21da89e29de772eb0085fa6b5b10da83ebbafc748efbbaeca"
    sha256 cellar: :any, ventura:        "65e8d2f3c80dadb8ff0e8897a7a5b56d98fe4ecdf261776903fc1a2f574b4b09"
    sha256 cellar: :any, monterey:       "b38ec39775785a60d725b2303ce0519908200ad108123130ef5f22a31f793416"
    sha256 cellar: :any, big_sur:        "7818036fffb71815bc4371d2c2e821a115859f41bde4d0a68a5304dbbc4d0ea2"
    sha256 cellar: :any, catalina:       "68ef71a51736943af8ac806c29ace444af9367578af97cf4103354dfb4f215e4"
    sha256               x86_64_linux:   "5db013a18650eefbbdd78d5d163a27df6494e9735f3758ec88ce414180af5c27"
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
