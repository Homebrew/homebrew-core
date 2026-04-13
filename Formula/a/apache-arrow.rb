class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-23.0.1/apache-arrow-23.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-23.0.1/apache-arrow-23.0.1.tar.gz"
  sha256 "bd09adb4feac11fe49d1604f296618866702be610c86e2d513b561d877de6b18"
  license "Apache-2.0"
  revision 5
  compatibility_version 1
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e43fc39f51623585ea9c7d7de4dccdafa37152bdbea0a413f6cd5cc6446616e5"
    sha256 cellar: :any, arm64_sequoia: "7caf6d02ca97bf04746481cff2c158d5f910ff21dcf8bbe00c19f0e90177ea1b"
    sha256 cellar: :any, arm64_sonoma:  "c8ad69531de221c415fa8b3aabae2a18dad47637490b41d78df0f4d78e973c96"
    sha256 cellar: :any, sonoma:        "29389a8e980f9ab9ad5a8722a567771b7fdfbce650a43b56f01b3b6e24c1dd2e"
    sha256               arm64_linux:   "89d97ab20a68a988c6585d4977003d14345c41aabb8e3b4cadfbd78644d00976"
    sha256               x86_64_linux:  "fef8442e49da985c3568aafe3e23ed8d4851cbf02fd7b18fef3e517a7cc20490"
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

  # Apply open PR to support LLVM 22
  # PR ref: https://github.com/apache/arrow/pull/49429
  patch do
    url "https://github.com/apache/arrow/commit/03d40603d9f29a107a5cede0f94e6c0241cd6099.patch?full_index=1"
    sha256 "22fdd4a15a80a7bf41b899ba1ef5fdcf8c761cbd3bbd1470cd5db2c5a543e8af"
  end
  patch do
    url "https://github.com/apache/arrow/commit/7b9135aab4ce6b8a79e0037ead8093d10174e7d8.patch?full_index=1"
    sha256 "bb08d0ddf5b3fcb8cee1c354ea0be25a2a246bbef8fd311cc89637b52090bd8e"
  end

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
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-larrow", "-o", "test"
    system "./test"
  end
end
