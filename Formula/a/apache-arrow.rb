class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-21.0.0/apache-arrow-21.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-21.0.0/apache-arrow-21.0.0.tar.gz"
  sha256 "5d3f8db7e72fb9f65f4785b7a1634522e8d8e9657a445af53d4a34a3849857b5"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e222457fd8c35bb5deceecc47a5df1866a9136b22d78cd1075429985d455b5fc"
    sha256 cellar: :any,                 arm64_sonoma:  "e90d4f54cd48074e188355d4e4d28cb6bb6488e65b08ca7477a97889b13138e9"
    sha256 cellar: :any,                 arm64_ventura: "3e274aa22190b078d9cbc96e89e529b55d8430ae33a92c567d66e13fc94f11fc"
    sha256 cellar: :any,                 sonoma:        "bac18fb5fe48ceb9ddc5c09cdc991d46b3d92f19a3c3c08ed87ec09b5ea44f88"
    sha256 cellar: :any,                 ventura:       "941af5a700b522392061282de516af031c51311a43fc7e079e7beae564f1479a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d089204012095602f7e06442520f65415d809367c3fd7367579da5f0d1a356e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "483cabe4f2cd3cbe2492f6e640ae26d646453455492182560d4fb6ce088ce8b7"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "gflags" => :build
  depends_on "rapidjson" => :build
  depends_on "xsimd" => :build
  depends_on "abseil"
  depends_on "aws-crt-cpp"
  depends_on "aws-sdk-cpp"
  depends_on "brotli"
  depends_on "grpc"
  depends_on "llvm"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "re2"
  depends_on "snappy"
  depends_on "thrift"
  depends_on "utf8proc"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  # Issue ref: https://github.com/protocolbuffers/protobuf/issues/19447
  fails_with :gcc do
    version "12"
    cause "Protobuf 29+ generated code with visibility and deprecated attributes needs GCC 13+"
  end

  def install
    ENV.llvm_clang if OS.linux?

    # We set `ARROW_ORC=OFF` because it fails to build with Protobuf 27.0
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DLLVM_ROOT=#{Formula["llvm"].opt_prefix}
      -DARROW_DEPENDENCY_SOURCE=SYSTEM
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
      -DARROW_ORC=OFF
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
    # Reduce overlinking. Can remove on Linux if GCC 11 issue is fixed
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,#{OS.mac? ? "-dead_strip_dylibs" : "--as-needed"}"
    # ARROW_SIMD_LEVEL sets the minimum required SIMD. Since this defaults to
    # SSE4.2 on x86_64, we need to reduce level to match oldest supported CPU.
    # Ref: https://arrow.apache.org/docs/cpp/env_vars.html#envvar-ARROW_USER_SIMD_LEVEL
    if build.bottle? && Hardware::CPU.intel? && (!OS.mac? || !MacOS.version.requires_sse42?)
      args << "-DARROW_SIMD_LEVEL=NONE"
    end

    system "cmake", "-S", "cpp", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV.method(DevelopmentTools.default_compiler).call if OS.linux?

    (testpath/"test.cpp").write <<~CPP
      #include "arrow/api.h"
      int main(void) {
        arrow::int64();
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-larrow", "-o", "test"
    system "./test"
  end
end
