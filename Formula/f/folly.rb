class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2025.03.10.00.tar.gz"
  sha256 "c375a4fdf9785f49e53a602bdfc023668062d37887d5127b97bd6c289ab5f8f0"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eb0a6764edd67cf5a2d97b268384e009768d6b2054cad169fda55e25a4bfdce0"
    sha256 cellar: :any,                 arm64_sonoma:  "3621a485b8386ce8911f841d0eed01f82aa96b25d93d251eaf03b2e29cd9c166"
    sha256 cellar: :any,                 arm64_ventura: "1975dae7302c3b63d28e953b7d869570b7a0fcfb305958819ae3bbc0b3280582"
    sha256 cellar: :any,                 sonoma:        "6ceab777ed6434ac3cc64cd81c56907be0b275a448ead18b9887dd9be1ffa81d"
    sha256 cellar: :any,                 ventura:       "02752d66648bfe9958e245336215d709894c7f941fc9d87d400f5bffb3c8d83d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57ed5c0f57d7af472f35592f910708c61b279c49468aab3402e1fe5b53ef6d36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d990e8af39d617b19cf88236a62440bd8d4727025ab0f9cfec0faddf2d9006f"
  end

  depends_on "cmake" => :build
  depends_on "fast_float" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "snappy"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    # https://github.com/facebook/folly/issues/1545
    cause <<~EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::path::lexically_normal() const"
    EOS
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = %W[
      -DCMAKE_LIBRARY_ARCHITECTURE=#{Hardware::CPU.arch}
      -DFOLLY_USE_JEMALLOC=OFF
    ]

    system "cmake", "-S", ".", "-B", "build/shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static",
                    "-DBUILD_SHARED_LIBS=OFF",
                    *args, *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/libfolly.a", "build/static/folly/libfollybenchmark.a"
  end

  test do
    # Force use of Clang rather than LLVM Clang
    ENV.clang if OS.mac?

    (testpath/"test.cc").write <<~CPP
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
    CPP
    system ENV.cxx, "-std=c++17", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end
