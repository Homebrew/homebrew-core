class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-10.0.1/apache-arrow-10.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-10.0.1/apache-arrow-10.0.1.tar.gz"
  sha256 "c814e0670112a22c1a6ec03ab420a52ae236a9a42e9e438c3cbd37f37e658fb3"
  license "Apache-2.0"
  revision 5
  head "https://github.com/apache/arrow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "3161a8b79ae0afd5b54ed7d5e4b7f8fc1d4ec5809fb3fc1d58747f6fcdd382d5"
    sha256 cellar: :any, arm64_monterey: "b505108edaaf96c0be5054bba9d750af077934a7ec6c6599ce1179007cee5c43"
    sha256 cellar: :any, arm64_big_sur:  "5a8cc6ca99db70a3743e6ba3d39d73f40182789c9e0ad8a0e92c706ebe7e33f5"
    sha256 cellar: :any, ventura:        "f2a9a0759fc9ded5cdf2e31049cfce135f547304c3d877e01b571408e46c7380"
    sha256 cellar: :any, monterey:       "d66b222eda9ac27862d3755f34ef56e1acd03f64c0cc0b41b5e805cfb9dbadba"
    sha256 cellar: :any, big_sur:        "80e686ee93fe4fa4762435d5d2d34d79e5dbfd83f8006bba133440fe20cac524"
    sha256               x86_64_linux:   "5b7cb597be7d2db70451c5dabbaaebfe7b4f703fe3383cb3f144e11e96129705"
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
