class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-14.0.2/apache-arrow-14.0.2.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-14.0.2/apache-arrow-14.0.2.tar.gz"
  sha256 "1304dedb41896008b89fe0738c71a95d9b81752efc77fa70f264cb1da15d9bc2"
  license "Apache-2.0"
  revision 2
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "f1a7e16ecf60d32bc677da130627640243535949d566ef4a2009f87bb48ed30d"
    sha256 cellar: :any, arm64_ventura:  "4faa45517882509317601dea55ecaf5b9d2a0359f3917d917e47195a07e32be0"
    sha256 cellar: :any, arm64_monterey: "f141c5a1f771d16816b6c7b529f02ad6cc5ae006ed9fc338dfc0caeaa7afb188"
    sha256 cellar: :any, sonoma:         "02c1b79f45250b28657d60552e7cb8cd0cfb5c916e9043277c019f2779445177"
    sha256 cellar: :any, ventura:        "98b1bad3a9c2eadad8f2b4cc060ff0eed29b4e51c6d37267461391f39854f311"
    sha256 cellar: :any, monterey:       "2f0d1465d5e340f4e4b15de2d71897a7490d4016164adb5aaa99b3aa5bc94105"
    sha256               x86_64_linux:   "3f30a4d743e1fc6a35ed255c04d0b570977776fed69c0bab2a312db1710988b6"
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
