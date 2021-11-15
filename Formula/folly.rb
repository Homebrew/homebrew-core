class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2021.11.08.00.tar.gz"
  sha256 "26f33869c663aa416df57d4c6ba2266fb47c66bddd514b9cd1b5e08cf7a6df01"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bc8304a2f58e56f5280e7963a43b633c2dc8714518af26d25a6f890bcaf9baf7"
    sha256 cellar: :any,                 arm64_big_sur:  "f989cda57fdfb076e5f86ce690526fc94dd931d880d0e718cff33537218d4cf5"
    sha256 cellar: :any,                 monterey:       "8f0eb14a68df7d0fcb6d1fa450309fc0d8b6446f8bd9542634e9dd05eef0b743"
    sha256 cellar: :any,                 big_sur:        "623b31c867956b376bcdc05dec51f6cf80c5fd7acd37f77b2b25fb4ebc2f778d"
    sha256 cellar: :any,                 catalina:       "ab4edaf5922efb4a3b327981be78589e06e6f4136f3a435fc87fe0523bf16087"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c080072a7bc09fcbecf6f4832aa89916cadf82c6fb4328ab573834796219df0"
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

    mkdir "_build" do
      args = std_cmake_args + %w[
        -DFOLLY_USE_JEMALLOC=OFF
      ]

      system "cmake", "..", *args, "-DBUILD_SHARED_LIBS=ON"
      system "make"
      system "make", "install"

      system "make", "clean"
      system "cmake", "..", *args, "-DBUILD_SHARED_LIBS=OFF"
      system "make"
      lib.install "libfolly.a", "folly/libfollybenchmark.a"
    end
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
