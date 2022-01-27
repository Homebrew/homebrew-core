class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2022.01.24.00.tar.gz"
  sha256 "5c8511eaed524da292ae7f624269153d45533995cb88e34f487ded49f8db388d"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7ef180f898a7ce15c6f424999e3e3182713ad70f87b6735ada1886092f4c9cea"
    sha256 cellar: :any,                 arm64_big_sur:  "a5508f744832976e114f085644c7e7380477d371adf6efe0b2735535eed93b1a"
    sha256 cellar: :any,                 monterey:       "f59b3b84d8c5ac7713f7c857c3850a7fc4dbfbcc8c27bc316af709e118da0369"
    sha256 cellar: :any,                 big_sur:        "eea023fa5e3b4c8b73e1207a3c7f23af327b125c7bb6c527715354a7cd604089"
    sha256 cellar: :any,                 catalina:       "26df6c22c09a0730c84db7a2a27d6dbe9d06eeba700257aa03d1ce5e5789595f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7d59844f9738f1bfccb782e85a2928009dc319a0914beffdeefe88f62183c16"
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
