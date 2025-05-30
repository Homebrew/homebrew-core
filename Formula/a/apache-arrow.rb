class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-20.0.0/apache-arrow-20.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-20.0.0/apache-arrow-20.0.0.tar.gz"
  sha256 "89efbbf852f5a1f79e9c99ab4c217e2eb7f991837c005cba2d4a2fbd35fad212"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cd25ff2c5e53b329095229cce306740755dbc3aa6b3d51391bb420e6c4a88126"
    sha256 cellar: :any,                 arm64_sonoma:  "38fe55ee10b77866913ce2cbed86e75488cd0c5703eb3c383f4db8973f20a8ed"
    sha256 cellar: :any,                 arm64_ventura: "4561146c557a0a0f19fe09400089e6483fec5fa2753ce517c48d80851f40b10b"
    sha256 cellar: :any,                 sonoma:        "f958b66fd1a4a0140a3d3688fba76af1ca216633d6abfdd53643a2a72ff9001b"
    sha256 cellar: :any,                 ventura:       "b75e17c47868396564e99e640c5190789276633ed34f8f9befefc3e17f8c718b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6413c358d91a03d90b95e35c7ca8e0d1af2355f199558871d7c7eab5d34e0c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bbc725958b822ca238d6840c93f86090ea4d8aafed7cb3c79f32852ba69c59a"
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
