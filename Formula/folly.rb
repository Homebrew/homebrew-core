class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2022.01.03.00.tar.gz"
  sha256 "364ebc7087487a1780636e4be8a08e51272dde26dc9ff89f4e785483f64925cc"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "20904e39321951e5856f003db70b081ee25394927a1a754d1d42b81022340938"
    sha256 cellar: :any,                 arm64_big_sur:  "281714ecc5cbd0016e0bd84d5dfa0f4e2d8df81af0a68d5367076690fd033e12"
    sha256 cellar: :any,                 monterey:       "f8ec55a8c7cc1f9657fec518ac84a0331a5708952089d1ac5bc632fc9ac335f2"
    sha256 cellar: :any,                 big_sur:        "5c121af41d971562bc91b7827b3753eda72f6daa26f24afcaf1166b13c4a0bb0"
    sha256 cellar: :any,                 catalina:       "14227f364913f4a60e74afc42d1ab1c5307c80a3e9d576a94f28b26c9270e09c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcb347e872c08ab0dbd59a089cb48ecf605b82981c33068728d026624e48b932"
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
