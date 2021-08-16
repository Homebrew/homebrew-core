class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2021.08.02.00.tar.gz"
  sha256 "2f9b0ff1af934ca715028462985b6c22004f2599af157bab475857ffc9a5688d"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/folly.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "01bbe77385b9cd484ef4280bfef97148936d8d6b859efc4dea925fe8e737d701"
    sha256 cellar: :any,                 big_sur:       "8ec42644e8babdbb33e9a1fb258f7aa6935e11518410637b0992826fb306e15d"
    sha256 cellar: :any,                 catalina:      "2e1e6034b3be3811e9738df39c28e14ada5314c88466863421a4a6678f484c15"
    sha256 cellar: :any,                 mojave:        "8fa0b4668333687a08af61eafd3310a10ea877b6e89782d8b4dacf6591bf5844"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5088ab110dd2cd205944c2032733af5571a85a466abaa43ff9a4513a8873ea4d"
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
    on_macos do
      ENV.llvm_clang if DevelopmentTools.clang_build_version <= 1100
    end

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
    on_macos { ENV.clang }

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
