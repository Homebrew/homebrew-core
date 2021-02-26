class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-3.0.0/apache-arrow-3.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-3.0.0/apache-arrow-3.0.0.tar.gz"
  sha256 "73c2cc3be537aa1f3fd9490cfec185714168c9bfd599d23e287ab0cc0558e27a"
  license "Apache-2.0"
  revision 3
  head "https://github.com/apache/arrow.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "bffa46572a4fff64ee125416b12c2e8678c474ae78620a77fa430ec93ca115e3"
    sha256 cellar: :any, big_sur:       "9422df11994b5c90026558e420b17c84ee0ee15fcbae654b2e7e2006844146fb"
    sha256 cellar: :any, catalina:      "b007ab3307ce60c9346e0ed099f7f8e9fa354aa085c5df616913a9b2789b1966"
    sha256 cellar: :any, mojave:        "2b4d9d894397f9d7f26f8e51f8c751c6c541e8d944db1b5ba98f8d1a6f88ec98"
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
