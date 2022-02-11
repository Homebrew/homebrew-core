class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-7.0.0/apache-arrow-7.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-7.0.0/apache-arrow-7.0.0.tar.gz"
  sha256 "e8f49b149a15ecef4e40fcfab1b87c113c6b1ee186005c169e5cdf95d31a99de"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/arrow.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "668e69fba3ffbf72ecfb042838b8c3fd12e7289e09dd67978c61777240724c6d"
    sha256 cellar: :any,                 arm64_big_sur:  "4c70aa32c8b8cc783b7a1b39d4970c43be3d4b598cfbf128cfd2ecb1a678664a"
    sha256 cellar: :any,                 monterey:       "3cdd724fede35624965bd121a3eae6488e863fbacce3a74e32ff5643776d2519"
    sha256 cellar: :any,                 big_sur:        "e2b0ada7578093175186f7ab9118db2a2ee4c0d4a3dc084690480ef6317213e0"
    sha256 cellar: :any,                 catalina:       "55991f188503361ae4e29c5be2b06d284719f5fbe8b6d25ef1a59668dd872045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "262a5c5c35427627a7903418f1fa6a2ce5a98c35de324de118f058a1374212e3"
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

    # https://github.com/Homebrew/homebrew-core/issues/94724
    # https://issues.apache.org/jira/browse/ARROW-15664
    ENV["HOMEBREW_OPTIMIZATION_LEVEL"] = "O2"

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
