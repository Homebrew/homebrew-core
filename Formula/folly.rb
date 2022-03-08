class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2022.03.07.00.tar.gz"
  sha256 "a52f21d5f6791160f4ff2242071f91c33c8b486687ce6345e52ef90f0ace49af"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "024267f2c54b49f4e09aa9dfdd6c7dac3b5ab9204b9663b82a8af88893e1aff6"
    sha256 cellar: :any,                 arm64_big_sur:  "908b874b1bdd7c5c2a8f69b9fdc9a5adfc6738adea28a3ceb0ac0f345732a7bc"
    sha256 cellar: :any,                 monterey:       "55b36a8b1bc43dc1dacf5bf7c5bfdb7aa9816dee7c89aa7a7fe616c73acb9855"
    sha256 cellar: :any,                 big_sur:        "6c47b9439ae426643b93fd28ef28a8e16f3f587378aec74ecdc679879428bad5"
    sha256 cellar: :any,                 catalina:       "2aa80de17c5657a2b6700801dabd60663bbfaf8d4ea24c6ac07275f8e45fc488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10fff8a0f032cb50938df68089ba3b99eb8d24a499e93b2bbceb3a3af1c6909b"
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
