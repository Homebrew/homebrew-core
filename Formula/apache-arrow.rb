class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-9.0.0/apache-arrow-9.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-9.0.0/apache-arrow-9.0.0.tar.gz"
  sha256 "a9a033f0a3490289998f458680d19579cf07911717ba65afde6cb80070f7a9b5"
  license "Apache-2.0"
  revision 4
  head "https://github.com/apache/arrow.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b2dfd69e5b83c4f72293200d2df8de09b4584c621a5e7b818c295a1d34970f52"
    sha256 cellar: :any,                 arm64_big_sur:  "4d63e3038c418862e0571183b40c41527a6b575b2b5a4edb4bfb52ba4eed3fa2"
    sha256 cellar: :any,                 monterey:       "9c93a889afda69ea6b9242bcf4218d63a1ec64bd07369f68cffb67e08b42c6d8"
    sha256 cellar: :any,                 big_sur:        "875d5650155dd800350eaa4d5c8857c05414b268e7b18644514a1dba2ce0fa2b"
    sha256 cellar: :any,                 catalina:       "82eb35e64d479b9aa009b39931922e252714dc3a211d16eefeae9fc2a5f09f51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f17f836100c2efa596da0d148dd71fd3529f93ed23ecb75129087b0477232e9"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "llvm@14" => :build
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

  fails_with gcc: "5"

  def install
    python = "python3.10"

    # https://github.com/Homebrew/homebrew-core/issues/76537
    ENV.runtime_cpu_detection if Hardware::CPU.intel?

    # https://github.com/Homebrew/homebrew-core/issues/94724
    # https://issues.apache.org/jira/browse/ARROW-15664
    ENV["HOMEBREW_OPTIMIZATION_LEVEL"] = "O2"

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
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-larrow", "-o", "test"
    system "./test"
  end
end
