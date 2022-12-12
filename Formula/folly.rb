class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2022.12.12.00.tar.gz"
  sha256 "14b083e829306f65c2981e37948b3c4b9331640fa88e10500458b825c1237edd"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ec64c80fc874825b238e31c231d84243884f442eb4104bb43b2bd73b9b8f06dc"
    sha256 cellar: :any,                 arm64_monterey: "a7522b5cd9483299c6166a26054c6be993f9099e1a25cc0f472f99826ab5bd75"
    sha256 cellar: :any,                 arm64_big_sur:  "39dd6fc4e7fbe263d1fc15a92c0c923ffd094a2c726adc6491bedfc16c665551"
    sha256 cellar: :any,                 ventura:        "f00d2aa2f037065339d4eac2663a231fabc1d3289756ec733bc6630013eca1a0"
    sha256 cellar: :any,                 monterey:       "5126e8f2d7de60949f0ce925ce199abcdc5a37ae8b3f60b45aa34bdf3c9fd0df"
    sha256 cellar: :any,                 big_sur:        "0c693ceb728c853947e653df4992d665035b77e48de7c3e26f48c651d68b40cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fabf23444ea9b1f734c9da9019262bca16b9259752bf0a7500d5eb3cfe409a2c"
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

    args = std_cmake_args + %W[
      -DCMAKE_LIBRARY_ARCHITECTURE=#{Hardware::CPU.arch}
      -DFOLLY_USE_JEMALLOC=OFF
    ]

    system "cmake", "-S", ".", "-B", "build/shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static",
                    "-DBUILD_SHARED_LIBS=OFF",
                    *args
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
