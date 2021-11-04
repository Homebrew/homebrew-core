class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-6.0.0/apache-arrow-6.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-6.0.0/apache-arrow-6.0.0.tar.gz"
  sha256 "69d268f9e82d3ebef595ad1bdc83d4cb02b20c181946a68631f6645d7c1f7a90"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "7c9a038737d54b3f44273440c5db77e279b553835ccc70fc2c08a115d2510369"
    sha256 cellar: :any,                 monterey:      "421fd5a3d91dfdb8ad600852643806f6d9c0da3c60143aa61fdc064f834708f9"
    sha256 cellar: :any,                 big_sur:       "414b06b7281fdd4c6b730c12e68cd452b18657e1804967fc11ff75ec182095e7"
    sha256 cellar: :any,                 catalina:      "b06d9eb6e1b2c569a2f64e2e1ac8de34abff40ea5b4e599de32024baf7022dcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b2271ef3d6b0a0871f9e1f9c3f4c1a9c6af9cbde3b67a75fb2859276f5f72b3"
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
