class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-16.1.0/apache-arrow-16.1.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-16.1.0/apache-arrow-16.1.0.tar.gz"
  sha256 "c9e60c7e87e59383d21b20dc874b17153729ee153264af6d21654b7dff2c60d7"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ac0dd5d854dcf71ca51d21b2fe1cd9ffbf75a15da90122e28da4af9d92381787"
    sha256 cellar: :any,                 arm64_ventura:  "5411746ace8f933243ce2d501d81989b7e6b3063a7b89ddc28b7465e4fd5f7ee"
    sha256 cellar: :any,                 arm64_monterey: "d5da86c470314084f8da2ac6f0d04d8d8c080db9691dfa7bf8df13d54982ee24"
    sha256 cellar: :any,                 sonoma:         "e5da567570b24b6722e24b031ba98f42b34edcfb61875ebdac47b34361a55ed8"
    sha256 cellar: :any,                 ventura:        "f5307a48ed582e11735fe5eace86f1241420423dc8e098f4fe9a12099e8f6cfd"
    sha256 cellar: :any,                 monterey:       "6dc56628a4304ee2a5593c3eb75d50165df1e96d974fe06ef0d5a18049b478e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ecb311049bc28908eb85ba8feb2b768e87231448c74b3b4b475bd9cc49777e6"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "abseil"
  depends_on "aws-sdk-cpp"
  depends_on "brotli"
  depends_on "bzip2"
  depends_on "c-ares"
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
  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    llvm = Formula["llvm"]
    ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm.opt_lib if DevelopmentTools.clang_build_version >= 1500

    # We set `ARROW_ORC=OFF` because it fails to build with Protobuf 27.0
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DLLVM_ROOT=#{llvm.opt_prefix}
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
