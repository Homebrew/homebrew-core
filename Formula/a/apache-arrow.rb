class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-15.0.1/apache-arrow-15.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-15.0.1/apache-arrow-15.0.1.tar.gz"
  sha256 "55db63ed9fd6917b7abfe5d4186c9f532cbe48aa53f4040d57e7c29ad70bcefa"
  license "Apache-2.0"
  revision 2
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "1b13ceafd41a6d07e2d33815df47c0f1092252a0d1eb5276998b2824e9ad8001"
    sha256 cellar: :any, arm64_ventura:  "19535059627d877da3a193fc436c0e126a9e6aaa8ec75aa31333fb6538f75569"
    sha256 cellar: :any, arm64_monterey: "21604b9c8ffcd25f50e0797e6e46841e4c477b5d9da10917c2b4169b43d86ceb"
    sha256 cellar: :any, sonoma:         "9d330990004c9920346adea6d2423d693af73010cd8efbdd74c3b0743b085dbb"
    sha256 cellar: :any, ventura:        "bda7d9ca0fed3086b085abb59b01c307740bc0e67796c7f8d64308b1ab1fcab0"
    sha256 cellar: :any, monterey:       "f3bf8fc3be69de6968eb81ff814350bf05ca64f174fc880db82aecaf6f6bae70"
    sha256               x86_64_linux:   "b04504f02b4f9bffd0a7b928c162c39686bc19b09cf6a7515352fbd1ad69f549"
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
