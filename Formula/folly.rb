class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2023.01.02.00.tar.gz"
  sha256 "3d9798dae415ac2beb437f7a1054dcf4e3de9f2c100bb55a486a147a8978bf74"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3a4a4888c1a63ddda1a0460646eb861ba4d51854f3292ac88fdb1c6464b1a21a"
    sha256 cellar: :any,                 arm64_monterey: "4660ca5aaac1a832975eff6cbdd3485a156ce5e14531db5124e2b8b34c0dabaa"
    sha256 cellar: :any,                 arm64_big_sur:  "e28d4e2b4148042c9b04b8193e6efcc6d94104b261e4637c168837f655b5ed9e"
    sha256 cellar: :any,                 ventura:        "12f6a5b39d01e9e6d436d3485d4225844755c66b90d3f971bcca3f33f62177be"
    sha256 cellar: :any,                 monterey:       "9769f81d2c652202f5d56a5a3da58156ec6dd2bcdce363ba5b77af03393e49d9"
    sha256 cellar: :any,                 big_sur:        "7382b2ed5b16f9fa82838cfc71406640d52b578e8afa29a3f31adfefefd688ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c77e9242a7a5cbe4b7436a0af045d83a6be0a40281949cb76805aff4a9797560"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "snappy"
  depends_on "xz"
  depends_on "zstd"

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

    args = std_cmake_args + %W[
      -DCMAKE_LIBRARY_ARCHITECTURE=#{Hardware::CPU.arch}
      -DFOLLY_USE_JEMALLOC=OFF
    ]

    system "cmake", "-S", ".", "-B", "build/shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static",
                    "-DBUILD_SHARED_LIBS=OFF",
                    *args
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
    system ENV.cxx, "-std=c++14", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end
