class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2025.11.10.00.tar.gz"
  sha256 "62fde99e074f7402938c29cf6faff7fcceac2524956ab339f13946efa3c334b0"
  license "Apache-2.0"
  revision 2
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "de38dcb26d6796e22e11446f52426ba1c02bb9f7de231d8d8f29237d5452fdb7"
    sha256 cellar: :any,                 arm64_sequoia: "c90ba6f15c5616dcf90dc91fe3f0268e76336e6bc1020b3d0ac8890897173c5d"
    sha256 cellar: :any,                 arm64_sonoma:  "463902f2dafd8cedd7b1323896d8683f59ca2cb98c1ab25441116cee7dec0a97"
    sha256 cellar: :any,                 sonoma:        "b05134875ac89fa872f705c22dd103979ee197c113534aa7a32c4c992751d372"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "402c5c34cde748dc2c0fa0176f11538602265fc580d862fa4ba0ab1f0c693099"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9e1dcf95fb4a161c495c68599116f60223da933489bdf0ffcb6471f067f0ab6"
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
