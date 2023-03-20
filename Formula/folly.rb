class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2023.03.13.00.tar.gz"
  sha256 "a7ee2e55b282a870eb2b743efc16497db8d6ac3343b121b2c8fda5caa021136e"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5c0b2edb0fbfb447cd07fb33204636e42f3d8564e7eefb17b763e0354c9a8f37"
    sha256 cellar: :any,                 arm64_monterey: "b71442d6ce172e22a5ce100dc2c4305aad1d2e829955d8b756007f4249339d18"
    sha256 cellar: :any,                 arm64_big_sur:  "a93460cafe82ce19271bc6d64d4cb8fb2766c8ee44ea05007ec4f8210574bed4"
    sha256 cellar: :any,                 ventura:        "b4364ead00acb2cb5d7b8adc7a8692c13f9448b1826ad098ea727bb5b580ffcb"
    sha256 cellar: :any,                 monterey:       "87bbcae8da59d85f6e6fe636022b6b842a84a0d5c80e08fb316248f9cd520633"
    sha256 cellar: :any,                 big_sur:        "bc80211573564db2456a3fef28cd480cdc4ee906372091b0cdfbd8976d4a1ac2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1cfd1d3648bb33d39bcbc514bc02fa42a135e0fc83fa6d61bf0d19f18afaf3d"
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
