class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2025.04.07.00.tar.gz"
  sha256 "414e489a9056945ae3afc2e770be52141df3a5b2eb908d0e8150a0ca2d099e0b"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1146eaedc6ccb77be98410805e2262daa5fa0d30f89225e191a2001005e7ebe7"
    sha256 cellar: :any,                 arm64_sonoma:  "2be6e267d2492f6cfea90438964fa25aa2967cf317e469d1b9c6c79f54bd1db8"
    sha256 cellar: :any,                 arm64_ventura: "06b2135e028aa1def363a0b440ce105aa4dd2df15fc6f4ed55aee7eb5ade72e9"
    sha256 cellar: :any,                 sonoma:        "3d81370cf44fb977f36dff8bbbdb7ddb7923480ca9cef1df3d41a274501be1e7"
    sha256 cellar: :any,                 ventura:       "575ee00e156314c15bdbbbec8687b66a5bd56ecf41327abb6157e03cbf3943b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c85a809e429a4daaca2ef98404d8bb6ec74bd7a97e31173c890f6c9d1bbc258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e10d011b7e1d3549b85360e609b8c55ba78011c0bff848e073dea5dc1430fcb"
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
