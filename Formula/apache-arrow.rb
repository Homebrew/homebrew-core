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
    sha256 cellar: :any,                 arm64_big_sur: "3804d8b82fdd7b36ad0e82491408ff315bcc4c56253530b354955e54e543d0b4"
    sha256 cellar: :any,                 big_sur:       "1d67d76e7b9f8d68b712ab23fe9977d2508964eed5f7a1a73ddec73f473ca6b2"
    sha256 cellar: :any,                 catalina:      "f4a59a9614221748dbc98ba1ac168bc7111d3d339c292091e21a06fa71ac9626"
    sha256 cellar: :any,                 mojave:        "5fadbd4efb0c9f842bbb56bb3dc848f40da404b432d2b5b90f65939b3002c5d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f7d29c7b3987d8b4f30587367c753313c964e681fa67932256e344d252bece5"
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
