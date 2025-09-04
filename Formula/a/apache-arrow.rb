class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  license "Apache-2.0"
  revision 5
  head "https://github.com/apache/arrow.git", branch: "main"

  stable do
    url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-21.0.0/apache-arrow-21.0.0.tar.gz"
    mirror "https://archive.apache.org/dist/arrow/arrow-21.0.0/apache-arrow-21.0.0.tar.gz"
    sha256 "5d3f8db7e72fb9f65f4785b7a1634522e8d8e9657a445af53d4a34a3849857b5"

    # Backport support for LLVM 21
    patch do
      url "https://github.com/apache/arrow/commit/57b4b4b77df5ae77910a91b171fa924d4ce78247.patch?full_index=1"
      sha256 "8331efaf6ed21cba8d90ee802e685a8f113af11aa92da59457c36c06aa21dab6"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "a831bbc2b0bc3906d7a6cff8a9a7a2f135540146e974de25cb397c6ec8b0b206"
    sha256 cellar: :any, arm64_sonoma:  "ba9ff23dd0b501553dbe5dccff2899c37dbef928989c9c4738f00c4f6d4c6ac5"
    sha256 cellar: :any, arm64_ventura: "3855488d7c3df0b532c23340d18e3c91f4d1242e9c2ed9f25438d9ab02baacb7"
    sha256 cellar: :any, sonoma:        "2483e43494d672a1d71c4f98809e1fddba418ecd1b660bb2fd602ccec390a1d8"
    sha256 cellar: :any, ventura:       "2a58b770230894592bc4697cc0698a4a2ffb8687288fc3de79f96ba39385d083"
    sha256               arm64_linux:   "e07a6fd683cf1d8c97e12d430f8ab7e3b0e734b1596ae3bf90c93a16c1dfdd71"
    sha256               x86_64_linux:  "88c017ac20a81aa3a6fe845ac0a812f41774241b8a27f7ddd27e34d43df01525"
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
