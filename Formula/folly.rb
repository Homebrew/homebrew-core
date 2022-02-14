class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2022.02.14.00.tar.gz"
  sha256 "6ec28672a524e1d9d89cdb528d64362b939b4f0afc526767d93aa1ebb2639fc1"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d7b7201a69829e49cf0180959ee728633fa38fcff470bc00e1127880cc768ffc"
    sha256 cellar: :any,                 arm64_big_sur:  "0165edb95f607a914a63fb236f68b5870aafca9eaad6409ce2e25fbc05a10fbf"
    sha256 cellar: :any,                 monterey:       "a4908de99a0855dd62e00deb1f2e9283d10bc21de9acb07ba61a4c24f32b71fb"
    sha256 cellar: :any,                 big_sur:        "01149b1bc86247704c42680b0a1b11d6fc10981c1e5205a59612a2d473d6d371"
    sha256 cellar: :any,                 catalina:       "f75673f79cb0ea7e33b1ed90e5c004e72b2fe3439b25718829dc32944aa0a003"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd64cb39b0b0cc985aa5885b1df576ccf544a39a6909dfa677f1f3f84d95df31"
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
