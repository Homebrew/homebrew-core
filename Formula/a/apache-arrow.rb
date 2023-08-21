class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-12.0.1/apache-arrow-12.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-12.0.1/apache-arrow-12.0.1.tar.gz"
  sha256 "3481c411393aa15c75e88d93cf8315faf7f43e180fe0790128d3840d417de858"
  license "Apache-2.0"
  revision 4
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "ca657c77b7033631e3c9db74c7597fc7452e4c6fca589444becfdd5963d4c1a5"
    sha256 cellar: :any, arm64_monterey: "5f283251fd1967b9cdae1892ff7598383b67ae3ce4051588ee42fe7558949486"
    sha256 cellar: :any, arm64_big_sur:  "f42ebad4baf371d3f7674690aa1bcfcfa575acd9f26c9170c4a82179c684e72a"
    sha256 cellar: :any, ventura:        "0f9774784cfa73cdb8a31b0313b0e2f0735726775258851e771391f245f6c542"
    sha256 cellar: :any, monterey:       "292f873ce0f78687bd2d9123cd45125386836294a8debf4b310e3fdcdea3e609"
    sha256 cellar: :any, big_sur:        "7cbbff3babc645a7ef227d22a68d4e5ee76f6dc88250a99c4dccb52fa9e1ba6c"
    sha256               x86_64_linux:   "c16e37e338917cfe2b62ea5785ef1900d7583f398a5090d09dbd93248342128f"
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
      -DPARQUET_BUILD_EXECUTABLES=ON
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
