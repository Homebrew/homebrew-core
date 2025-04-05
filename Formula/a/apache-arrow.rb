class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  license "Apache-2.0"
  revision 3
  head "https://github.com/apache/arrow.git", branch: "main"

  stable do
    url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-19.0.1/apache-arrow-19.0.1.tar.gz"
    mirror "https://archive.apache.org/dist/arrow/arrow-19.0.1/apache-arrow-19.0.1.tar.gz"
    sha256 "acb76266e8b0c2fbb7eb15d542fbb462a73b3fd1e32b80fad6c2fafd95a51160"

    # Backport support for LLVM 20
    patch do
      url "https://github.com/apache/arrow/commit/c124bb55d993daca93742ce896869ab3101dccbb.patch?full_index=1"
      sha256 "249ec9d7bf33136080992cda4d47790d3b00cdf24caa3b0e3f95d4a4bb9fba3e"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6a09d0fb5f121754485c07be7088ed1f78f4d515b4317dcac4ab8d4b5055ed4b"
    sha256 cellar: :any,                 arm64_sonoma:  "22221ed0ac6df347b31879e430951c3aeb6c4fa3afaeabee9f9990b812ee641e"
    sha256 cellar: :any,                 arm64_ventura: "93ae16a11eddb0fa5c68439ac7253f0409c0cb388be499afbbb9c5642c1e16fb"
    sha256 cellar: :any,                 sonoma:        "9e8adadead6e7bf0c2d084db0c4026e104be73c448b057e16b240c5b928aa3d6"
    sha256 cellar: :any,                 ventura:       "0c2255f1a4bf326412577b2fd5d809abc6f4f96ae2fcb757adf1fb9663a7c3b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "249c2f58c7dd3144bc0b3f1515aa91083aae16ba214e5aaa20a3cfdd0f0e843e"
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
