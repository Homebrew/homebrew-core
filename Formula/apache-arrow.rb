class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-9.0.0/apache-arrow-9.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-9.0.0/apache-arrow-9.0.0.tar.gz"
  sha256 "a9a033f0a3490289998f458680d19579cf07911717ba65afde6cb80070f7a9b5"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/arrow.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "675bdb42b4308c62dd1056d91001ac65f067e113af1d28710690e3e83ec627b1"
    sha256 cellar: :any,                 arm64_big_sur:  "b945b8f87968cd0de97bcf0cc580e44d811d154f4233433d9222bbe0bfb161c2"
    sha256 cellar: :any,                 monterey:       "dc5e96f97bb3b302a2093681d97d15a9fb6a72634dc14de65b14843767508d62"
    sha256 cellar: :any,                 big_sur:        "d585365986b70606cbd7ecb73645b3e1e657bad8b7f0a7a8e0397f82e1ba2125"
    sha256 cellar: :any,                 catalina:       "e8c85a7367051336338f220c9c1a9f07f391b88c3cc8ec7ce6dd46692c860d09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e9c1cf39650817b1ccb51c2af9de7c57f6ad4bebccb85d8e6afb9a7e08eedff"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "aws-sdk-cpp"
  depends_on "brotli"
  depends_on "glog"
  depends_on "grpc"
  depends_on "lz4"
  depends_on "numpy"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "python@3.10"
  depends_on "rapidjson"
  depends_on "re2"
  depends_on "snappy"
  depends_on "thrift"
  depends_on "utf8proc"
  depends_on "zstd"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    python = "python3.10"

    # https://github.com/Homebrew/homebrew-core/issues/76537
    ENV.runtime_cpu_detection if Hardware::CPU.intel?

    # https://github.com/Homebrew/homebrew-core/issues/94724
    # https://issues.apache.org/jira/browse/ARROW-15664
    ENV["HOMEBREW_OPTIMIZATION_LEVEL"] = "O2"

    # link against system libc++ instead of llvm provided libc++
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
    args = %W[
      -DCMAKE_FIND_PACKAGE_PREFER_CONFIG=TRUE
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DARROW_FLIGHT=ON
      -DARROW_GANDIVA=ON
      -DARROW_JEMALLOC=ON
      -DARROW_ORC=ON
      -DARROW_PARQUET=ON
      -DARROW_PLASMA=ON
      -DARROW_PROTOBUF_USE_SHARED=ON
      -DARROW_PYTHON=ON
      -DARROW_S3=ON
      -DARROW_WITH_BZ2=ON
      -DARROW_WITH_ZLIB=ON
      -DARROW_WITH_ZSTD=ON
      -DARROW_WITH_LZ4=ON
      -DARROW_WITH_SNAPPY=ON
      -DARROW_WITH_BROTLI=ON
      -DARROW_WITH_UTF8PROC=ON
      -DARROW_INSTALL_NAME_RPATH=OFF
      -DPython3_EXECUTABLE=#{which(python)}
    ]

    args << "-DARROW_MIMALLOC=ON" unless Hardware::CPU.arm?

    system "cmake", "-S", "cpp", "-B", "build", *std_cmake_args, *args
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
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-larrow", "-o", "test"
    system "./test"
  end
end
