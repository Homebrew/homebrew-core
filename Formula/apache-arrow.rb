class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-11.0.0/apache-arrow-11.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-11.0.0/apache-arrow-11.0.0.tar.gz"
  sha256 "2dd8f0ea0848a58785628ee3a57675548d509e17213a2f5d72b0d900b43f5430"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "5afb5c2776ab7af0eb81fb024ceb38a757391de897ba293e425f2f6f02e1e84d"
    sha256 cellar: :any, arm64_monterey: "cc26e599d5be1978f825e51ff314c987a4d381087cde7eb0908db7a1bf44c342"
    sha256 cellar: :any, arm64_big_sur:  "fdc290b1cb63ecd16ea7ced20334b59b74450ef2aa1f4eb52c3ab4d840deadf7"
    sha256 cellar: :any, ventura:        "2431c602d0eb3dc430fcc07d71df523668061d0ec873b9e4520e4887d6773402"
    sha256 cellar: :any, monterey:       "a4286b3f8ad741b018760c6fc9b8e387df57524b4f0e2fcf819f5ef7903d60a1"
    sha256 cellar: :any, big_sur:        "b61c9c4c8b4905b15db680b27c9f78a2a27fed1a5faf1196fae24ec8e73d6b6d"
    sha256               x86_64_linux:   "50141f865ab994211b665d80c2540e6293044430d83311574023d2b52625ea7b"
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
