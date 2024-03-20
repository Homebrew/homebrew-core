class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2024.03.18.00.tar.gz"
  sha256 "fc10684d7acaaa6bd8e57e129503cb2524b7433bff95aa40d4fed2c59b93fb60"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a18fb9216ba7b341bd7d6aebc2ea9983b1eb3f7f663fbc48c0f2f93d7f168b4f"
    sha256 cellar: :any,                 arm64_ventura:  "8334d3ae69283e86a1821031283a9132ac4133ffdf93c5c76b35966f8185a235"
    sha256 cellar: :any,                 arm64_monterey: "980e51f371f5d68cccab4620ea294e0767cfcd3ad02b96e2926cb1c50c4c73ab"
    sha256 cellar: :any,                 sonoma:         "9d4657a96b19a6976cbad98cdf2392529fd7606b433c6bedec203323449d7c5f"
    sha256 cellar: :any,                 ventura:        "59fc0252a1cf0424e80d0d16d9945a33554d4ff3ae3cc26d0738b52ae8f82158"
    sha256 cellar: :any,                 monterey:       "4383976a192421a4239da8577abea4b62cc3309f8413ce50b33551be3a52f2c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ffb4dc93d046b27cd36e2b4f378b9998fc0ce8d827ac9f2f7a1c0eb6ddf6ded"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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
    system ENV.cxx, "-std=c++17", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end
