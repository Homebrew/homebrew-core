class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-25.0.0/apache-arrow-25.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-25.0.0/apache-arrow-25.0.0.tar.gz"
  sha256 "12afc2dc8137bdd4a68876cec939f664c9d55cfc7b75f55b45163ebb4e344d81"
  license "Apache-2.0"
  revision 2
  compatibility_version 3
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a083648b231583e2e16463deef79e3fe43a3333ac98352ccc64991002c993391"
    sha256 cellar: :any, arm64_sequoia: "c49c38604188a2a6b251be8dca9968ef5afa85a3ec8a28ddd400fd05bf432d17"
    sha256 cellar: :any, arm64_sonoma:  "c266b4a144240748768da67aeb4058afe023518987df3fd3d008bf015eef2f79"
    sha256 cellar: :any, sonoma:        "8aa751212ba84876704ac7f513bd86fcea76f0dc69e84761c6bd4a789ab41207"
    sha256               arm64_linux:   "1bfb19dbb87e04d26f799b32b6160cb8b424113d6f8c2fcb5a9449ece0e3e762"
    sha256               x86_64_linux:  "fc742e7caa0718d0707d5be71602eb1619a4b7ea4007c121232bfd6683a26d49"
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
      -DLLVM_ROOT=#{formula_opt_prefix("llvm")}
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
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac? # Reduce overlinking
    # SVE bpacking kernel fails a static_assert; disable SVE runtime dispatch
    args << "-DARROW_RUNTIME_SIMD_LEVEL=NONE" if OS.linux? && Hardware::CPU.arm?

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
