class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2025.04.28.00.tar.gz"
  sha256 "2198e153707459df9e931e07009aea9d6ef5fc8ee1a244c24761d326f3a21393"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c27c5787b15bb544ec71985cf13e3c5122885e47306456fa09ac9f878a4b4f92"
    sha256 cellar: :any,                 arm64_sonoma:  "9828d83906a429cfd6d969d551e3efd98e82a35ef69b8814fe634ba326575659"
    sha256 cellar: :any,                 arm64_ventura: "30a70c608e74d2e5a24ba66d38984a1e7063b21f97faf71389276c92dfb479ea"
    sha256 cellar: :any,                 sonoma:        "988560a7f3274780dfd44eda99a5a7d5ed0704ec72728e69ce1fe1d9e803d660"
    sha256 cellar: :any,                 ventura:       "9bfccb24fd140416675be2ae201b268c7f781a074e1d53440a7df0275297ff91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35565e9e6167a1804a1092ce611da4a4e0bace199e13ebebbe8f03a82356bcc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e1cc51b5d681855fa6a1796c60b76677f89239562066ca9928928efae349189"
  end

  depends_on "cmake" => :build
  depends_on "fast_float" => :build
  depends_on "pkgconf" => :build
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
    cause <<~EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::path::lexically_normal() const"
    EOS
  end

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

    (testpath/"test.cc").write <<~CPP
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
    CPP
    system ENV.cxx, "-std=c++17", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end
