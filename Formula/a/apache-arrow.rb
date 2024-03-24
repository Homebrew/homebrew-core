class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-15.0.2/apache-arrow-15.0.2.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-15.0.2/apache-arrow-15.0.2.tar.gz"
  sha256 "abbf97176db6a9e8186fe005e93320dac27c64562755c77de50a882eb6179ac6"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "212979d37eecda7d7bd96152546be83a3646ee14213a66910a78bb80ecbfff79"
    sha256 cellar: :any, arm64_ventura:  "35030bd144d89a4c18491d97ec7db61e978781f96c0f7f688c2bc534624a5460"
    sha256 cellar: :any, arm64_monterey: "20b817d8502c0dc1cc57d10c4e3fe607fab769de3946164e0ff42c31cea64763"
    sha256 cellar: :any, sonoma:         "84f8823f8be28afd64dec988af0adc41927dfca4aed710f8e2a35e7673aa6596"
    sha256 cellar: :any, ventura:        "1c1843fa95e6030dfcd385eced67ef2381ea627882820dc6099d2c7053110b6f"
    sha256 cellar: :any, monterey:       "bacd798943b7f5441ca6db68a1c95283f7614c752ecc75995d505600a3e39a35"
    sha256               x86_64_linux:   "77a42a925c2979f5baa2dcb4162025ae44c815e353e520b410b5dff2da9ef15e"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "aws-sdk-cpp"
  depends_on "brotli"
  depends_on "bzip2"
  depends_on "glog"
  depends_on "grpc"
  depends_on "llvm"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "rapidjson"
  depends_on "re2"
  depends_on "snappy"
  depends_on "thrift"
  depends_on "utf8proc"
  depends_on "zstd"
  uses_from_macos "python" => :build

  fails_with gcc: "5"

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib if DevelopmentTools.clang_build_version >= 1500

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
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
      -DARROW_ORC=ON
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
