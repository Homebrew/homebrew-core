class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-6.0.1/apache-arrow-6.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-6.0.1/apache-arrow-6.0.1.tar.gz"
  sha256 "3786b3d2df954d078b3e68f98d2e5aecbaa3fa2accf075d7a3a13c187b9c5294"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/arrow.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "48bf3a19006a49e8d580e32e96cff84efb85ca5dfad256d11d78cd7c0ea6bbd9"
    sha256 cellar: :any,                 arm64_big_sur:  "c9030f80bfab2cfe13df83a716ab364c1b9394ac53ded64aa26aaebb90ef4282"
    sha256 cellar: :any,                 monterey:       "b1481a404b40a4d271b5d7d49103ea5df74d2b2df10d1e5d9bf4e1c8bc1a1c07"
    sha256 cellar: :any,                 big_sur:        "a87eff51d98069a22bec7aee06787b6629b6250ba9524c2aab748d33e0c59c0d"
    sha256 cellar: :any,                 catalina:       "b6e20d95739d8596e60906799d9d5111c251753834b2e38aa89e3af8a7b45922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "164c02c8b15dd1d753dc5bda6b7a8d2f5255ebe2275c53b1aa8f408727093716"
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
