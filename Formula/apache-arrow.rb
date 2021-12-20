class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-6.0.1/apache-arrow-6.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-6.0.1/apache-arrow-6.0.1.tar.gz"
  sha256 "3786b3d2df954d078b3e68f98d2e5aecbaa3fa2accf075d7a3a13c187b9c5294"
  license "Apache-2.0"
  revision 3
  head "https://github.com/apache/arrow.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6f30dc4a3962ccd822812ae8f22d21820af8769dff5f9627928eb00da4dcab4b"
    sha256 cellar: :any,                 arm64_big_sur:  "54978d31ece5e424e7f4f7acd0b2573a5612d34e715bb57a5a06ea107e875ca6"
    sha256 cellar: :any,                 monterey:       "f5848a06a8341f43aede38dbbe8a420ecf635004010af79e5fd75c8276543304"
    sha256 cellar: :any,                 big_sur:        "4c5437aec9f9d1b203c408ecff1dd884d31d0914a99e9cd4964358b4522bc51c"
    sha256 cellar: :any,                 catalina:       "54c1a40cbedc71f35f4ae8ce499e9b0b54c99be4c4da33f58ab60c8e2970b2f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1097dbf83586423ea752dee7f28b66586b4aaf3f3303ba1fb91f47af55f23f6"
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
  depends_on "python@3.9"
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
    # https://github.com/Homebrew/homebrew-core/issues/76537
    ENV.runtime_cpu_detection if Hardware::CPU.intel?

    # link against system libc++ instead of llvm provided libc++
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
    args = %W[
      -DCMAKE_FIND_PACKAGE_PREFER_CONFIG=TRUE
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
      -DPython3_EXECUTABLE=#{Formula["python@3.9"].bin/"python3"}
    ]

    args << "-DARROW_MIMALLOC=ON" unless Hardware::CPU.arm?

    mkdir "build" do
      system "cmake", "../cpp", *std_cmake_args, *args
      system "make"
      system "make", "install"
    end
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
