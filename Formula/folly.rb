class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2023.07.03.00.tar.gz"
  sha256 "a442f8aff36eed0929827576e7249aa40fd874fb36a262548d94d711c0e28737"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ecc191855e59e976352ddf14d22f10081ea66dd20ed7c6c565038c6eb77953d8"
    sha256 cellar: :any,                 arm64_monterey: "19a18f62aa87a280bc0a14ae9b9f471edf520a3fa3f996a35a0bcb42e6ec118c"
    sha256 cellar: :any,                 arm64_big_sur:  "61841f62593afb5ccd2a713a9ece6381fec038d95c5aecaf2f5c153dfd91d3be"
    sha256 cellar: :any,                 ventura:        "27adbd6d3bd9ba9783d8c496df8e1bae2d658983fe2eda6b9a4f15c625e5be5f"
    sha256 cellar: :any,                 monterey:       "fd9868ecb7d780c452c3174cbc7e08ff0dacc14b4c958c9f27d3f836d0094399"
    sha256 cellar: :any,                 big_sur:        "2ccb9a527f914e336e966d39403f40f0862eb86810108d313022ae18e5d7a9eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1af06fbad13db51c55abc306b3d9050a07ab6d776301fd990d4c697993210cca"
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
  depends_on "openssl@3"
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
