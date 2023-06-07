class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  # TODO: Check if we can use unversioned `grpc` and `protobuf` at version bump
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-12.0.0/apache-arrow-12.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-12.0.0/apache-arrow-12.0.0.tar.gz"
  sha256 "ddd8347882775e53af7d0965a1902b7d8fcd0a030fd14f783d4f85e821352d52"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "3bb8574e52dd8e94c636d09aab08174a5822ea14927917f4a400a7e00b48fdd2"
    sha256 cellar: :any, arm64_monterey: "8c19f90473b224648a25b1d23e974f039f621495d9f18ca991ea7673f402ec10"
    sha256 cellar: :any, arm64_big_sur:  "1889a94c0ca7010102563ab31f1a8ec9375fa55f00ca219f8612d3b739f8a3a9"
    sha256 cellar: :any, ventura:        "56567213d0de5e3e81c4793021104b014664369bcf4aa29307a402fb5ec2dd1c"
    sha256 cellar: :any, monterey:       "4e134c301e0535fc4b59d7d4b6bc33a4d791c838f5d3feb52ce6bedbd366f917"
    sha256 cellar: :any, big_sur:        "00dfa2cef14924fa86ffeb6b14044faa9036227e046d6cfb3ef6387b01096d5b"
    sha256               x86_64_linux:   "bcded666d0bc385253af82203b23386c2d589446bbc9cfe02e7e237f0f508ba9"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "llvm@15" => :build
  depends_on "aws-sdk-cpp"
  depends_on "brotli"
  depends_on "bzip2"
  depends_on "glog"
  depends_on "grpc@1.54"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "protobuf@21"
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
