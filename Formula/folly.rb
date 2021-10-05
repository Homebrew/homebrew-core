class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2021.10.04.00.tar.gz"
  sha256 "67bbbcc7dac0661edc95d9dd29481c4b9eaa913d1819bb5709270390731503be"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "79846a72da2a208b2a80357141905e6177b81e275925a450ce62e33c5c140eba"
    sha256 cellar: :any,                 big_sur:       "f795fe4f193b470fcb28508c1a26a6b35e5e032496b4682be40cdc09cdc45d8b"
    sha256 cellar: :any,                 catalina:      "7323915550b11dfdb6eb9b36cb228223de776fe7c4b8776bc13db5a267479e71"
    sha256 cellar: :any,                 mojave:        "a1a61783c6cdeda761eb165985a446d772cdb4a8f910052ec8c8258bd361693d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29472234cdeb809e84b3455c9028f1a9ca74a16f7f55e2eafcd631d9a0c7d616"
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
