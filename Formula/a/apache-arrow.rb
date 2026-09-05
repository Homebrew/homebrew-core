class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  license "Apache-2.0"
  revision 5
  compatibility_version 3
  head "https://github.com/apache/arrow.git", branch: "main"

  stable do
    url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-25.0.1/apache-arrow-25.0.1.tar.gz"
    mirror "https://archive.apache.org/dist/arrow/arrow-25.0.1/apache-arrow-25.0.1.tar.gz"
    sha256 "43d5de0a581f43cf63a2c06b4dcf13b9ff6fcd800f023324596e5781093bc500"

    # Apply commit from Debian maintainer's upstream PR to support CPUs older than SSE4.2.
    patch do
      on_intel do
        url "https://github.com/apache/arrow/commit/d048f71964fe2df5540be2256048eb15f830962b.patch?full_index=1"
        sha256 "1a6b6924e505f4d1c70a24240e52be90b00aa25b116e7db52fd69f76d2b7e189"
        type :backport
        resolves "https://github.com/apache/arrow/pull/50547"
      end
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "44d5ae8fb0e6da618bdc437d1e29c37c23eabdd89bbdcd5ce1514fd50a136454"
    sha256 cellar: :any, arm64_sequoia: "765d8f9d70326d0bfd9a3e19e9f5f3a5f06dc9d3a9af37a6ce448e63484145f3"
    sha256 cellar: :any, arm64_sonoma:  "3dd69c6e0799074a0cf357ed8842937e6a32309ab3a693d5567653009222bd8f"
    sha256               arm64_linux:   "1dc5c127f5b8411771fe23f2572b1324f4ecfbbdfe55157e386c04ae49649e1f"
    sha256               x86_64_linux:  "8a10b4b625932f9724d6e648c9acdcc8a134be0e4a0f7421df133b94a0038325"
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
  depends_on "llvm@22"
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
    ENV.runtime_cpu_detection

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DLLVM_ROOT=#{formula_opt_prefix("llvm@22")}
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
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac? # Reduce overlinking

    # ARROW_SIMD_LEVEL sets the minimum required SIMD. Since this defaults to
    # SSE4.2 on x86_64, we need to reduce level to match oldest supported CPU.
    # Ref: https://arrow.apache.org/docs/cpp/env_vars.html#envvar-ARROW_USER_SIMD_LEVEL
    #
    # NOTE: Do not remove this while Core 2 is oldest supported CPU
    args << "-DARROW_SIMD_LEVEL=NONE" if Hardware::CPU.intel?

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
