class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-11.0.0/apache-arrow-11.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-11.0.0/apache-arrow-11.0.0.tar.gz"
  sha256 "2dd8f0ea0848a58785628ee3a57675548d509e17213a2f5d72b0d900b43f5430"
  license "Apache-2.0"
  revision 3
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "3d443a435cd127cafcdae52520ea227e22f110152274c6387f4bc6cc827a7097"
    sha256 cellar: :any, arm64_monterey: "03c6343ba6a667dea2e563a995fa72a683f6042e8673a675090e4584d03909d4"
    sha256 cellar: :any, arm64_big_sur:  "398a5aa9743d676c05f6382d7c3542239af46f85c913efe8fa1421ff35006850"
    sha256 cellar: :any, ventura:        "c5c119841562a42b9d88dcf916b514d775d45fd3950767ff4ce234a25768fe64"
    sha256 cellar: :any, monterey:       "d2055ca46f3d973a7eab9b7a73ee723d9ec043c012211505ee1f2cbbfb1d1ef0"
    sha256 cellar: :any, big_sur:        "4d300aed6d13558d56ce90f3306f597877b08436ddfdd121863a53585ba05186"
    sha256               x86_64_linux:   "deb39810dc3b7e8f3bdae2f76f34ebc5c544f2db1eb178bbb801f78eda3169cb"
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
  depends_on "z3"
  depends_on "zstd"
  uses_from_macos "python" => :build

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
