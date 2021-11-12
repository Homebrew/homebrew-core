class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2021.11.08.00.tar.gz"
  sha256 "26f33869c663aa416df57d4c6ba2266fb47c66bddd514b9cd1b5e08cf7a6df01"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "67dcb4ad4611273a5f77110cbd4cba756dba89f3ace71fac6ad8543e1021422d"
    sha256 cellar: :any,                 arm64_big_sur:  "10dca6ba8ff3cacb5530937c60786dc2211b7b7b3a7a817f98b69b5834d45212"
    sha256 cellar: :any,                 monterey:       "5c189c141f1c725bab9c38fcec2c47482771c64d33ac67062415b31aec006272"
    sha256 cellar: :any,                 big_sur:        "8d9b1aba953e0cf40fcebae521a0b7cf7838f02c6ad93519c58ea106b729cd73"
    sha256 cellar: :any,                 catalina:       "14619a9d5bb477dc622b55a82e88d769cc5a4c8b224bb2e959f9fc3e9fed1eda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4557a3c385ef24b070f2607355546b9ab257afa0aad5b0462fb6d68e971fe3d"
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
