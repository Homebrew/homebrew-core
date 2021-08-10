class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-5.0.0/apache-arrow-5.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-5.0.0/apache-arrow-5.0.0.tar.gz"
  sha256 "c3b4313eca594c20f761a836719721aaf0760001af896baec3ab64420ff9910a"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/arrow.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "2fde45fd60e6e8ded9d49800c6c610504e8e79489ba1b458457593754e2cf951"
    sha256 cellar: :any,                 big_sur:       "e0f9feb7dbe72ef09b646d4ca4a3ce75b8dcea072d4a2c1e13f8df85025ea205"
    sha256 cellar: :any,                 catalina:      "a7e51898ea6da7655f11738ebbc98e45624b404981b0ee09266961e4a090a33c"
    sha256 cellar: :any,                 mojave:        "4acd758fc7a032303ca2c8caff65d0ae2e195eccb6916b92912cfd6513edfc72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2257a9769d20f73b264def012c8db137cc32e5a0602ec25237bcda42e0671ec"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "llvm" => :build
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
      -DARROW_WITH_BZ2=ON
      -DARROW_WITH_ZLIB=ON
      -DARROW_WITH_ZSTD=ON
      -DARROW_WITH_LZ4=ON
      -DARROW_WITH_SNAPPY=ON
      -DARROW_WITH_BROTLI=ON
      -DARROW_WITH_UTF8PROC=ON
      -DARROW_INSTALL_NAME_RPATH=OFF
      -DPYTHON_EXECUTABLE=#{Formula["python@3.9"].bin/"python3"}
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
