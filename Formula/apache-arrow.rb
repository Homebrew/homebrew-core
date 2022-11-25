class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-10.0.1/apache-arrow-10.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-10.0.1/apache-arrow-10.0.1.tar.gz"
  sha256 "c814e0670112a22c1a6ec03ab420a52ae236a9a42e9e438c3cbd37f37e658fb3"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/arrow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "de7c9b20e373639b22511f3aef108a63af051540aa543481aa50e636e82b8316"
    sha256 cellar: :any, arm64_monterey: "b67394645b00145fa5e57e2349d30e0d39fd7b03c83b948b06313d730e6b5f0d"
    sha256 cellar: :any, arm64_big_sur:  "b371d6bb35cc626332125375491fd66a697ee4c8817459e6279db9738e7e0f16"
    sha256 cellar: :any, ventura:        "e351891dd18277ebefe9c6e99a21f123af6a7431ed4b80a7d20dc0be8b1b7ad2"
    sha256 cellar: :any, monterey:       "0095e564e35655256af1d9a42d5a5c9d57725d43dbc8be7f36c185f5f922d72f"
    sha256 cellar: :any, big_sur:        "930e6b68ec925fa0719efc8630c09ea1cc99492aad899453950ede310c48a518"
    sha256 cellar: :any, catalina:       "ee0d2b8c65f9901998a4fdb9c1e042b7b0be406c1fe6413601d99beedaa65f59"
    sha256               x86_64_linux:   "cf913cd75e77754f3c6df5cd42191aa34538161c64cc284e6c83c706b58b34d9"
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
