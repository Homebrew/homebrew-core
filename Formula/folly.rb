class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2022.01.10.00.tar.gz"
  sha256 "53454399388741be70701686cbb715168de6f8f0abf9b1c01f2e7c0a80091aad"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0f9d518d29cc06945a885d48a425067a8f1181f915d1c509b6fa8836f6d8d3a1"
    sha256 cellar: :any,                 arm64_big_sur:  "416145b8ac1f0719e20fef75970c82e15ca0bef8d694020b69aab8bc9f0f53fc"
    sha256 cellar: :any,                 monterey:       "dcbb49e1c0163cadc0dd1690aef67e6909768e506b9df9b303fa1cc2a4731f65"
    sha256 cellar: :any,                 big_sur:        "faeeff2436e27a9f6786a5fda1af306e8c2c0fabec1a1a0f89ffeceaa6ffc060"
    sha256 cellar: :any,                 catalina:       "14963c44aed7552edf025a565aef0f04f9e050e6d6faafc88271abd9eac3d9c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d57207f45833a027f028b969dfab5c37002f4da4d0cd84128145b79baab4b6f9"
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
