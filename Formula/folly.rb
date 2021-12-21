class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2021.12.20.00.tar.gz"
  sha256 "1e780708cd23cb01b62b4db09ef02ba36f8949a8a8115d3398fd395e748a9343"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b331f052c7d54eeee100075a98bc9827c40c9ea99a816ce38675185414720618"
    sha256 cellar: :any,                 arm64_big_sur:  "1ad779f2e74ac717d3bacc0f5d5e1df1d34adc5391eeffb1bb4d1b4d558859e7"
    sha256 cellar: :any,                 monterey:       "1a4d4f40e51c54fdb7f70b6b48d5d7547e289e8c1e6736ec11cd23d60569803d"
    sha256 cellar: :any,                 big_sur:        "4aa51ed8bff4ff3b240fcf17a67c02806cc0c86f0c593c0257d54a7ff18280ca"
    sha256 cellar: :any,                 catalina:       "5660ad232a8ebec66fe1f711ee1b4bfbffd67349c7091f762682da287d9b8af5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1a2765371a7d15b39619024c7a3af704776bba0cde39512c8b345023d4989e8"
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
