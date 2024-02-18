class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-15.0.0/apache-arrow-15.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-15.0.0/apache-arrow-15.0.0.tar.gz"
  sha256 "01dd3f70e85d9b5b933ec92c0db8a4ef504a5105f78d2d8622e84279fb45c25d"
  license "Apache-2.0"
  revision 2
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "0b3a73c54305d53cc6e3c2818a4ae765327fc9e100991098614ba361ba491b16"
    sha256 cellar: :any, arm64_ventura:  "7a003ea49c9130c33b41041b4964281df35276540978a8d67db49969879c260b"
    sha256 cellar: :any, arm64_monterey: "6ec797a28f1e076c2031c540740f4d181f7dda2410e6246ac9229553141882e1"
    sha256 cellar: :any, sonoma:         "0017cb0956330d036cf5c0268725c240c3e5cc94358d97334f2d8d63ec70c74c"
    sha256 cellar: :any, ventura:        "ee725cfed4ed68af08f3ef2c76389d4515847d4b812d5aba8dcd69df262e04fb"
    sha256 cellar: :any, monterey:       "0745c9c32fa834b7e53478b473d46d5db8661d37bf2f6655cfe95c92ac79328e"
    sha256               x86_64_linux:   "59c877f41f0cce676d22f83fc6e0b4ed1394147fca0519bd89cda6801a3c29f4"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "aws-sdk-cpp"
  depends_on "brotli"
  depends_on "bzip2"
  depends_on "glog"
  depends_on "grpc"
  depends_on "llvm"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "rapidjson"
  depends_on "re2"
  depends_on "snappy"
  depends_on "thrift"
  depends_on "utf8proc"
  depends_on "zstd"
  uses_from_macos "python" => :build

  fails_with gcc: "5"

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib if DevelopmentTools.clang_build_version >= 1500

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DARROW_ACERO=ON
      -DARROW_COMPUTE=ON
      -DARROW_CSV=ON
      -DARROW_DATASET=ON
      -DARROW_FILESYSTEM=ON
      -DARROW_FLIGHT=ON
      -DARROW_FLIGHT_SQL=ON
      -DARROW_GANDIVA=ON
      -DARROW_HDFS=ON
      -DARROW_JSON=ON
      -DARROW_ORC=ON
      -DARROW_PARQUET=ON
      -DARROW_PROTOBUF_USE_SHARED=ON
      -DARROW_S3=ON
      -DARROW_WITH_BZ2=ON
      -DARROW_WITH_ZLIB=ON
      -DARROW_WITH_ZSTD=ON
      -DARROW_WITH_LZ4=ON
      -DARROW_WITH_SNAPPY=ON
      -DARROW_WITH_BROTLI=ON
      -DARROW_WITH_UTF8PROC=ON
      -DARROW_INSTALL_NAME_RPATH=OFF
      -DPARQUET_BUILD_EXECUTABLES=ON
      -GNinja
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
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-larrow", "-o", "test"
    system "./test"
  end
end
