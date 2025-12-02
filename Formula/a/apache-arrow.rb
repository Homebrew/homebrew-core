class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "main"

  stable do
    url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-22.0.0/apache-arrow-22.0.0.tar.gz"
    mirror "https://archive.apache.org/dist/arrow/arrow-22.0.0/apache-arrow-22.0.0.tar.gz"
    sha256 "131250cd24dec0cddde04e2ad8c9e2bc43edc5e84203a81cf71cf1a33a6e7e0f"

    # Backport fix for `ARROW_SIMD_LEVEL=NONE`
    patch do
      url "https://github.com/apache/arrow/commit/00245cc802bc3be9a9cd169017f285586483fbb5.patch?full_index=1"
      sha256 "fb692196f928401bb8aca93f9a7af7e028f65705c170f31a300728b041a07a71"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7743ee7350aedc3b12d9c54a740e3ff83890b5a6fcb3297c1d6351d2f2131342"
    sha256 cellar: :any, arm64_sequoia: "a4852f0bd5f7e182e55ad260bbafe8ea99045290598e2c4765cb23c283bf0d02"
    sha256 cellar: :any, arm64_sonoma:  "e74b76da39a341a7e20c73a0381deca4318384b7fec7a6c88511be58cae6a7ce"
    sha256 cellar: :any, sonoma:        "a98519530182e8e8d2774b4d7dd473290e3df55a2cf4cdd92b5a1065d78b7ed1"
    sha256               arm64_linux:   "5442977618bc4bc96fdfefa43a44132db8a62d67160d1bac32506c7407513a13"
    sha256               x86_64_linux:  "234e84775c039de3ab588f02e680e99a3f1666f537bcc3c491da2dc1ff374062"
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

  def install
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
    args << if OS.mac?
      "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" # Reduce overlinking
    else
      "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON" # Avoid versioned LLVM RPATH getting dropped
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
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-larrow", "-o", "test"
    system "./test"
  end
end
