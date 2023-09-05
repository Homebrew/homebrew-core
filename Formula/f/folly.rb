class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2023.09.04.00.tar.gz"
  sha256 "9f0d6ec847b464aa1bdc2a8f0f707d46b86e8c4ee98365988288fbe269e07d12"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4cebe416a3d8a1ba9e09b304d5d65dca2bc5b02bd2a8a96dce65b2b469b82a9d"
    sha256 cellar: :any,                 arm64_monterey: "1b79a2348895fa82ba188445273773b3054f6b8ca083c7f5678b721f7c05a318"
    sha256 cellar: :any,                 arm64_big_sur:  "0b6cc8a85783ffdff3098ffb04221e16132f0015acc6ac92458699842161034c"
    sha256 cellar: :any,                 ventura:        "2437cf0511ff2ad1dfc8a30e9dd2dba86a621c896759b3ee1b2c153c48675afa"
    sha256 cellar: :any,                 monterey:       "3065f9bd410da380a197b4d992dc04314f0f0d6a0e7114d5566d025c83fe1a15"
    sha256 cellar: :any,                 big_sur:        "e8ebc7b761aa2d86d532e5295295c1ada006d639fef281ffc3368095989687fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d8baf870731118edf7d756735e17527bf43b571965e2f92bf81c3e26ed4058e"
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
    system ENV.cxx, "-std=c++14", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end
