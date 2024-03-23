class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-15.0.1/apache-arrow-15.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-15.0.1/apache-arrow-15.0.1.tar.gz"
  sha256 "55db63ed9fd6917b7abfe5d4186c9f532cbe48aa53f4040d57e7c29ad70bcefa"
  license "Apache-2.0"
  revision 2
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "a8434e8a3f42b85b17f281282bd4e3bd4e3fd507dda3818aa45855b2e12a4d77"
    sha256 cellar: :any, arm64_ventura:  "001ee8f702d916420f35b6bb06f35fa9291ad44ca4acce2ee315ba2de3f7142b"
    sha256 cellar: :any, arm64_monterey: "8bd406bdccc34ebb303809a22360df0f91f0ff166ceb807e78c92a0b4ce7b523"
    sha256 cellar: :any, sonoma:         "dce06a6381934b4f446ab342b2dd697442bc2e62b0189e543ffd6b87f0829cd8"
    sha256 cellar: :any, ventura:        "4d500708453b95d2b6044ae77c857bc734b8d290d41ef8798c13ffba3d0e9d93"
    sha256 cellar: :any, monterey:       "02b1b659e06fc3af48553e5bffa66ba0469795d4be17a57c9434a9061b74f688"
    sha256               x86_64_linux:   "fb25760532de4c17d4c7bfbd64989d89c7601e47ff8a704e19d5c8bcfb096118"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "aws-sdk-cpp"
  depends_on "brotli"
  depends_on "bzip2"
  depends_on "glog"
  depends_on "grpc"
  depends_on "llvm"
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
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib if DevelopmentTools.clang_build_version >= 1500

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
      -GNinja
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
