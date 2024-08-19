class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2024.08.12.00.tar.gz"
  sha256 "f6229c8b564aab912ebb8b9d7329c22865d20b37800408efa4e0166f630fe733"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "df26afdfa85c17e889148f62f461daa91f1249dcfcdf170139684ee94070003a"
    sha256 cellar: :any,                 arm64_ventura:  "56312f27584a7d3c55f2a500d5421418a24674e1930b3063772af4e4de5bb9bd"
    sha256 cellar: :any,                 arm64_monterey: "a87b36b60e6c80c6da515cca50f6f49858dfbf103d16cfec59b36d774d27b503"
    sha256 cellar: :any,                 sonoma:         "5616635c9a99df07d4b9ae666aa9aaf3fdb01d35ae052b1984335cd3b5ef9af0"
    sha256 cellar: :any,                 ventura:        "797f5670c44530e87791ebf3ebdb04ac4fb8014a24170778c219585f8cc133b9"
    sha256 cellar: :any,                 monterey:       "ddb89250e18e6f583fbf8ada4a2aa98113a35c4110cc0556f6b99f11516cabe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b276d9830e53c8099a9eb3d920e2284efdd2b9a535fccbbbdc8f2a3f3561767"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "snappy"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    # https://github.com/facebook/folly/issues/1545
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::path::lexically_normal() const"
    EOS
  end

  fails_with gcc: "5"

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = %W[
      -DCMAKE_LIBRARY_ARCHITECTURE=#{Hardware::CPU.arch}
      -DFOLLY_USE_JEMALLOC=OFF
    ]

    system "cmake", "-S", ".", "-B", "build/shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static",
                    "-DBUILD_SHARED_LIBS=OFF",
                    *args, *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/libfolly.a", "build/static/folly/libfollybenchmark.a"
  end

  test do
    # Force use of Clang rather than LLVM Clang
    ENV.clang if OS.mac?

    (testpath/"test.cc").write <<~EOS
      #include <folly/FBVector.h>
      int main() {
        folly::fbvector<int> numbers({0, 1, 2, 3});
        numbers.reserve(10);
        for (int i = 4; i < 10; i++) {
          numbers.push_back(i * 2);
        }
        assert(numbers[6] == 12);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end
