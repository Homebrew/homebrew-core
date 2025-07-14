class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2025.06.30.00.tar.gz"
  sha256 "c432fb6a53685f24ada08652bd6e3fcabeb50fa400667d2ab126874093a90c97"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4e30d409bcc8378fe474575de49930130b67d9b90916b876171a49907190b017"
    sha256 cellar: :any,                 arm64_sonoma:  "04e017c6416aa1d9891d8461037eb9982a7c0c16341b9d94f9823aa6c926b24b"
    sha256 cellar: :any,                 arm64_ventura: "7ea4f0af11822477a309fa03a4ec6167627af512dc3e2bf064f4f128f50abeba"
    sha256 cellar: :any,                 sonoma:        "3f7ec183e2a1ae08c882d9121b4cec8f0f32799b2074e83b53049b75bf29d161"
    sha256 cellar: :any,                 ventura:       "3e433019352cc4c075526da200c3cc33ac72bb8da4b01879c86e679988a4c037"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2b3a45033e6d90348c0ab0e63882ccfd68d3754b9b7f0745350c8bf10c4d265"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28a37bdb487b5efdc264351860dd56a0999e5f52af74e0890571538d69d6b17b"
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
