class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-24.0.0/apache-arrow-24.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-24.0.0/apache-arrow-24.0.0.tar.gz"
  sha256 "9a8094d24fa33b90c672ab77fdda253f29300c8b0dd3f0b8e55a29dbd98b82c9"
  license "Apache-2.0"
  revision 1
  compatibility_version 2
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "725827052d5622205be5a22b584fa371dd54dc4ed0ffb910c7c121900eee18cf"
    sha256 cellar: :any, arm64_sequoia: "f06e7d05526ea26d23ee2b4cf89e42deb65e8dd19c56e266103cef2537555d51"
    sha256 cellar: :any, arm64_sonoma:  "59e94b6daa2a495130d5f4239ae4c3e83f0a5ee0f8baa5c0f702559959bf85fe"
    sha256 cellar: :any, sonoma:        "0198edd477ebbd5b384c7d022b1b14a1ff2edb5710fa9e2081be2c12d13bf430"
    sha256               arm64_linux:   "07e853a572a9224f5a62359549546a3343843776302ff09fed91c7cfc6c970bc"
    sha256               x86_64_linux:  "7efac2027b0854793553b57a46609ee1a7da6f40eea1c81aaac58214846133ef"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :gcc do
    version "12"
    cause "fails handling PROTOBUF_FUTURE_ADD_EARLY_WARN_UNUSED"
  end

  def install
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
    args << if OS.mac?
      "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" # Reduce overlinking
    else
      # TODO: Remove after moving CI to Ubuntu 24.04. Cannot use newer GCC as it
      # will increase minimum GLIBCXX in bottle resulting in a runtime dependency.
      ENV.llvm_clang
      "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,--as-needed"
    end
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
    (testpath/"test.cpp").write <<~CPP
      #include "arrow/api.h"
      int main(void) {
        arrow::int64();
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++20", "-I#{include}", "-L#{lib}", "-larrow", "-o", "test"
    system "./test"
  end
end
