class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  license "Apache-2.0"
  revision 9
  head "https://github.com/apache/arrow.git", branch: "main"

  stable do
    url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-17.0.0/apache-arrow-17.0.0.tar.gz"
    mirror "https://archive.apache.org/dist/arrow/arrow-17.0.0/apache-arrow-17.0.0.tar.gz"
    sha256 "9d280d8042e7cf526f8c28d170d93bfab65e50f94569f6a790982a878d8d898d"

    # Backport support for LLVM 19
    patch do
      url "https://github.com/apache/arrow/commit/3505457946192ef2ee0beac3356d9c0ed0d22b0f.patch?full_index=1"
      sha256 "60793569736ebc72ecddcd06443cf281342d7fa81b5d4727152247f2cb7ad58a"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f411c20ea4914620fd382f3a20758201f814da354e278f32d85f58487bb8b87e"
    sha256 cellar: :any,                 arm64_sonoma:  "edf15aeb53a7086430f00b887733e15c9c36944054c635ff1f7db35af3a4051b"
    sha256 cellar: :any,                 arm64_ventura: "aa1b6d8b51c21d5f85e20e08ddc0969b7c1f50a0ec7db108ff122ad94bd89361"
    sha256 cellar: :any,                 sonoma:        "91ecb17642422cf3457e27b124ede15788e83bcbbda0634fd85fad7fdf5fe71e"
    sha256 cellar: :any,                 ventura:       "65c738d4286249ede5a7d0bc69d31186f4e9f12d03aa66770f80b1d915687843"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60103c33895e2ff5dc98233b4e203894983e199252afb7482f6c162059d02c44"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "gflags" => :build
  depends_on "ninja" => :build
  depends_on "rapidjson" => :build
  depends_on "xsimd" => :build
  depends_on "abseil"
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

  on_macos do
    depends_on "c-ares"
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
      -GNinja
    ]

    args << "-DARROW_MIMALLOC=ON" unless Hardware::CPU.arm?

    system "cmake", "-S", "cpp", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "arrow/api.h"
      int main(void) {
        arrow::int64();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-larrow", "-o", "test"
    system "./test"
  end
end
