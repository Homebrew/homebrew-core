class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2022.02.28.00.tar.gz"
  sha256 "1342c8bacb87482c8c6e96ad6ac9df58b5e9bd6f51a897cd71b4b345f08d7bce"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c27db3023e20757887da5297f8a150be2ffab5bb97e64ad6ce9713796a519989"
    sha256 cellar: :any,                 arm64_big_sur:  "f94cd43ff2e85f4daa3490cedf14d1d24a81a801429daf1f001383a279dab6f1"
    sha256 cellar: :any,                 monterey:       "60b8ce04dcee3afcec983a957cbc82bff899e534cc433de41dfeb50db134495a"
    sha256 cellar: :any,                 big_sur:        "a4c8c49b14b97f5811fba8967d70ec0f796ee71c181d71a14e6f5ff374614234"
    sha256 cellar: :any,                 catalina:       "d791bebd022e1466bc41d1e482ffd564da0ec7d54ca0a12fdd2287c80093454a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff71e175c6d153361169c78d69e5b5f21bb590aa528c527e80c5e6357c9c8211"
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
