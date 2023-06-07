class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2023.05.22.00.tar.gz"
  sha256 "3dd02b7184ad2da9ad8fd74ea5ba782384ebec9b568ce0880edd5d14dfb7debc"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "79828bb34a0cb6c17a3543af5ee5bfd94729b909a8f8ad1ece648e1c181eabdd"
    sha256 cellar: :any,                 arm64_monterey: "37c6c573503a76120404b861adf7f96ddaa00f4eb4e5d6f587fa85a0bdca96b8"
    sha256 cellar: :any,                 arm64_big_sur:  "3edb7dd188f64dfe9df113fc085ac1778707fa023e1cddcb05cf69300fd0f49c"
    sha256 cellar: :any,                 ventura:        "56c9feaf1116b5237247c3e21fd74fbfc510c6dd076fe050b06e6b7c61d44406"
    sha256 cellar: :any,                 monterey:       "bb4d75bf095fdb485e7e2bfe0a408bc6a3fc56a880d6e240de707c16c0324771"
    sha256 cellar: :any,                 big_sur:        "5f23d7d92a73092b4123c0857c9ce199f87e7fded09ce080354817a26561055c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1abbab95bc561405caaa4e351b663c7ca33c8d0cd361887900485eef8942ffd"
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
