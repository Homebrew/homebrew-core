class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-16.0.0/apache-arrow-16.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-16.0.0/apache-arrow-16.0.0.tar.gz"
  sha256 "9f4051ae9473c97991d9af801e2f94ae3455067719ca7f90b8137f9e9a700b8d"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d1b43f3931efacc42904e4123ce07fcdf0987c13a6f6c5a8c7b53b4102c36671"
    sha256 cellar: :any,                 arm64_ventura:  "96ac8542a1719313cc5e9eecec9919bb4ee4bfc60e5d80adaf4850ffa1257324"
    sha256 cellar: :any,                 arm64_monterey: "208f278c5170145b67f892e3b4afd0cf4f6dfb70b5a20a7f6855ee2e8dbdf73d"
    sha256 cellar: :any,                 sonoma:         "41b1d49cfd9ceb9e926c13148603595b5a8a0a83190faa1be2f165d5b849e355"
    sha256 cellar: :any,                 ventura:        "02c96eee2e13d84a3b44d36290fb3ad3d5b53e1dfac103c6365a3eb4201a8f46"
    sha256 cellar: :any,                 monterey:       "6dae0d977f5fbf6b1a1307d54d71106a2c997e8e2c86c88e51bd4bd16380304d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c76fbcb37ded8a2982ded4bb0dfcc41e8e72a21471dcbd40937556c0c6e6ad1"
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
    llvm = Formula["llvm"]
    ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm.opt_lib if DevelopmentTools.clang_build_version >= 1500

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
