class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-12.0.1/apache-arrow-12.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-12.0.1/apache-arrow-12.0.1.tar.gz"
  sha256 "3481c411393aa15c75e88d93cf8315faf7f43e180fe0790128d3840d417de858"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "0192449aa561b21a44a7e0144b541f64c5251e320203f538f263c7b0499d3c81"
    sha256 cellar: :any, arm64_monterey: "98efaf9e6d5e985bc7b85cae41de91abbf989f6b90541b9a17c975a06c9852fd"
    sha256 cellar: :any, arm64_big_sur:  "42050efb89839a021865afd2540ad9a902c2a474819aa07235c4f0c5b274fb8a"
    sha256 cellar: :any, ventura:        "f38c39e30d5612c0ce27c146ab8a21af8d5037077ab5dea7a85a6e1d18a26513"
    sha256 cellar: :any, monterey:       "b93773b25d859d9c610df3b7570975e3b941fd3a48fe0d45553bbc6b508dfa31"
    sha256 cellar: :any, big_sur:        "bfddf0c1da9bf696b20403c1bc402cd6ccdd975e472df8c91fdf8e5c18915dfe"
    sha256               x86_64_linux:   "3cd3ea9fbc43b5ab9120db38d32a8737904496ad3c5cffc41bc76a9357d9773d"
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
