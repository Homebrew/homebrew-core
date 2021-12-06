class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2021.12.06.00.tar.gz"
  sha256 "ef40cd400672ee8b784547bee964c1d2964504cadebfa0b8933128545de00961"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7c7077d15d4ce64fafbfc24b6d8522ebde5c7c069a408f455bc8f849e299a65e"
    sha256 cellar: :any,                 arm64_big_sur:  "94628ae711b44dd6c0d157bbfef064ca500bfeedb64595e14268811a5b003f3e"
    sha256 cellar: :any,                 monterey:       "122c9993e1cfd62cdfadc8907dbf9694ec0194d6a96534935210aea228edd14e"
    sha256 cellar: :any,                 big_sur:        "10c363b6122d01541aa3a0878431a179fe3d19dc405d0573e76229fbe5197cf9"
    sha256 cellar: :any,                 catalina:       "10263e19dad6f3651cf855d01d61505a4d6b7d0499896bef20dd2a566b2274f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9aaec452e41c08fb1a29edbdd17d1dc3502cbc9cbd72c082723bb6702847856f"
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
