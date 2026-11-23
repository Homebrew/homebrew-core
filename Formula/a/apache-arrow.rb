class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-26.0.1/apache-arrow-26.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-26.0.1/apache-arrow-26.0.1.tar.gz"
  sha256 "1dd1b6701d9de58a4ed82b107539682f46ef6b9e22747e18e03204125c05a987"
  license "Apache-2.0"
  revision 2
  compatibility_version 4
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    manifest_sha256 "672a1510eb9c0487f99ce037d91469cfadef046f7f349c487484a8fa36559116"
    sha256 cellar: :any, arm64_golden_gate: "54ed40b006e5393253a99f6120331b838ef9debd2fdc8955742907199c2360d6"
    sha256 cellar: :any, arm64_tahoe:       "55b5d0bcb07353684c6a0ed44919548814f595bb5bc24ae4392ccb611c5ee26d"
    sha256 cellar: :any, arm64_sequoia:     "f18c4518b1a4f4b6cb91a82dbe49222a9188197b066db5bad71adcf356f6bde8"
    sha256               arm64_linux:       "cdcccc2bf432611bfba1bce7e09c0bb59e3ac110fc9237465b2fc462f19ccc23"
    sha256               x86_64_linux:      "2abfb128e5d17216377b474a815e3559269623c8cdd0dfd8ba77510c64fcb42c"
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
  depends_on "openssl@4"
  depends_on "protobuf"
  depends_on "re2"
  depends_on "simdjson"
  depends_on "snappy"
  depends_on "thrift"
  depends_on "uriparser"
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

  resource "mimalloc" do
    url "https://github.com/microsoft/mimalloc/archive/refs/tags/v3.4.1.tar.gz"
    sha256 "37107a52c16baa80c5f74861dddda7b27bb9949e41a6637691867a94c88ca446"

    livecheck do
      url "https://raw.githubusercontent.com/apache/arrow/refs/tags/apache-arrow-#{LATEST_VERSION}/cpp/thirdparty/versions.txt"
      regex(/^ARROW_MIMALLOC_BUILD_VERSION=v?(\d+(?:\.\d+)+)$/i)
    end
  end

  deny_network_access!

  def install
    ENV.runtime_cpu_detection

    resource("mimalloc").stage("mimalloc")
    ENV["ARROW_MIMALLOC_URL"] = buildpath/"mimalloc"

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
