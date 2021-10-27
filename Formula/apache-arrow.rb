class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-5.0.0/apache-arrow-5.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-5.0.0/apache-arrow-5.0.0.tar.gz"
  sha256 "c3b4313eca594c20f761a836719721aaf0760001af896baec3ab64420ff9910a"
  license "Apache-2.0"
  revision 4
  head "https://github.com/apache/arrow.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "efeb4c5855d330a89b9cb39151d95c9efff12b69fa18808cfbfbcf0760da4d55"
    sha256 cellar: :any,                 big_sur:       "029209d3255f648149bf9fd95353b9cd9686aeb578c19dbcbc87e92c1d617bdc"
    sha256 cellar: :any,                 catalina:      "0d547dfdb6451da46222875a0a055d1646309355d76076532332ebc579a012c0"
    sha256 cellar: :any,                 mojave:        "18b9236e13bae6404e1b4011b146811437b4ade27fd1a757a6d4dc5099c27324"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73a003e658abdd920c398be5b7ce840bf8611d656eb630cca8372ca47dd44d21"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "llvm@12" => :build
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
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm@12"].opt_lib
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
