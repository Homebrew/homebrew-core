class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2025.04.14.00.tar.gz"
  sha256 "fde48016dfa0aaac21306777bef0338d7bdf12119c4cc5016a10114625c57abb"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "047194c7e9e4dc6be5a9860aa168556908e1cc53ed4ee8b26435b3c8cd826021"
    sha256 cellar: :any,                 arm64_sonoma:  "7fb7e11fabde0424292158d0e15a0ff9f91517e11c72c3f5e9d6886b3eb6a0e6"
    sha256 cellar: :any,                 arm64_ventura: "e7c0bb08fcaedec9c67f31f57931e2be1f5d29ff090161fe8ecf250ddee20a03"
    sha256 cellar: :any,                 sonoma:        "17c9b2526813e847c88ce699da5cbd60624ee6b0bae01e018c34c1945c42da8f"
    sha256 cellar: :any,                 ventura:       "347861aa347dd7d513b38c55843863edfd0e71a3e01ccf7527db9ab97e379f10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34c83802061f66b31216c7eef1d2634817ac8791758183c388680ae5bf392da8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48f0ffd51e7bff3848f3719a40b28063b749d7df31fdd5d97174e651b9554ba0"
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
