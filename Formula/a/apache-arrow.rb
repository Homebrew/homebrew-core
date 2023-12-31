class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-14.0.2/apache-arrow-14.0.2.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-14.0.2/apache-arrow-14.0.2.tar.gz"
  sha256 "1304dedb41896008b89fe0738c71a95d9b81752efc77fa70f264cb1da15d9bc2"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "ba7357fcece3d3917c9275a8ac72b5b5caf34981dcc11f75b5ba7f13bff48754"
    sha256 cellar: :any, arm64_ventura:  "8363efa515cba66d2226fc36f6fd1bb2e5f47cab1af9a95e1f19600d970cd56f"
    sha256 cellar: :any, arm64_monterey: "48e586221f27f85ea77d9ab1eea6754267fd92c602986d4d1792f8150312674c"
    sha256 cellar: :any, sonoma:         "b315d021f598a99c999b43b3940acaf8857f10fb55a7cc281080b5996c23516b"
    sha256 cellar: :any, ventura:        "b17cdb969de15019121d54949644883a143e1f633505a4f2a6eb8aa3fc081a2b"
    sha256 cellar: :any, monterey:       "7a39e0f96230367d3b5139a1c2e4015cf29ea8f9054e4c22939684595612ef6f"
    sha256               x86_64_linux:   "751618dcd8c2e5fc9bc5de8b927c5488e2ed291f9f5d5a37aaa467bd1089d617"
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
