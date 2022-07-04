class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2022.07.04.00.tar.gz"
  sha256 "6b270c1865c53b39f5d815cc2d97879a17dde6c77c5c127ede2a962ef3ab24b1"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d95ba6bd623924ac8d24a91c2fb165eb1f5eabc50d7f5cb0c50378dc04b76977"
    sha256 cellar: :any,                 arm64_big_sur:  "15bd7a6a3aec2adb9ebd3f68928cf00908e4e30e0d023f14b1982e18f6e18a05"
    sha256 cellar: :any,                 monterey:       "e9625d0973ee0dfdba1149b0decb45724880afb409aaa37d754ce2e616e5166a"
    sha256 cellar: :any,                 big_sur:        "f0f5b7a4f8f7b636a4c5db1b0ff852f44f3fdd58ce5f5518ef7ae6854b8c7552"
    sha256 cellar: :any,                 catalina:       "9f9c101c748c22ff4dc7aa585256d0ce89731ff471ce8c9155d88725c2117be2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbd3ea414840e07515fea999c3440a9e1f8eec9a6a0d5594febd27b2052762c3"
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

  on_linux do
    depends_on "gcc"
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

    args = std_cmake_args + %w[
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
