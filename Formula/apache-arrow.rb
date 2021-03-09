class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-3.0.0/apache-arrow-3.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-3.0.0/apache-arrow-3.0.0.tar.gz"
  sha256 "73c2cc3be537aa1f3fd9490cfec185714168c9bfd599d23e287ab0cc0558e27a"
  license "Apache-2.0"
  revision 4
  head "https://github.com/apache/arrow.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b81e86414bdfc588400d6b13c0dd993665fd2962d9ea25402f37ca7ccb86ce36"
    sha256 cellar: :any, big_sur:       "65659cf3529595b49ab5972e9b613fd7d60bc6481db8da30ade0aaa819517425"
    sha256 cellar: :any, catalina:      "3fbf2636d53f79cdfd26af1e0ee21d1b82d628d0320ace2941889bd875632a32"
    sha256 cellar: :any, mojave:        "f5024a74fa36d4ec80e6ebdb32dcb269e2dccba87c86d3b1c973207b362cc6bc"
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
  depends_on "zstd"

  # Remove in next version
  # https://github.com/apache/arrow/pull/9542
  patch do
    url "https://github.com/apache/arrow/commit/06c795c948b594c16d3a48289519ce036a285aad.patch?full_index=1"
    sha256 "732845543b67289d1d462ebf6e87117ac72104047c6747e189a76d09840bc23f"
  end

  def install
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
      -DARROW_INSTALL_NAME_RPATH=OFF
      -DPYTHON_EXECUTABLE=#{Formula["python@3.9"].bin/"python3"}
    ]

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
