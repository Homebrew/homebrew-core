class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-14.0.0/apache-arrow-14.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-14.0.0/apache-arrow-14.0.0.tar.gz"
  sha256 "4eb0da50ec071baf15fc163cb48058931e006f1c862c8def0e180fd07d531021"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "527033ed287018e1a3e96fa0bdf646745fe871247003b0ad35433a5142226e23"
    sha256 cellar: :any, arm64_ventura:  "61a418515c4731f61576575093c42acab169de43b3cf3cafcf57620ad7f0d76d"
    sha256 cellar: :any, arm64_monterey: "4e8c9c831023f5ed832fcfc2b164b91db755924ab38b114fe7fb852c6e9907fa"
    sha256 cellar: :any, sonoma:         "86dfdeff418fabcbfbab72793eefe534edfabaa1e2d73a3151f532e078dffa6d"
    sha256 cellar: :any, ventura:        "ee802e08a8e735b45ae1d8e97d3c87583a7fda1cf26639fd3eaaa8bf1f32062f"
    sha256 cellar: :any, monterey:       "bf64d118932a62af66994527bdd4be9ce5ab61f3be973b8fb130c1d7ff7727a6"
    sha256               x86_64_linux:   "536a1d3d7c5ee9c8c58aa4d3a1cfb0168599abd971745a88858b501311cc1470"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
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
