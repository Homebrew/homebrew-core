class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2023.05.08.00.tar.gz"
  sha256 "4984c4df54c38db46f1475bc34760650e86b8fe73a5883342cedbe20b4654553"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5c1ca72e8aadd993ebebb5fcde683f6e8321c712f1cf42dd4f60b5b1309522a2"
    sha256 cellar: :any,                 arm64_monterey: "86dcb16470eefcbadb353581c38837f1ea7123efaeadf413329aaa7b9d784752"
    sha256 cellar: :any,                 arm64_big_sur:  "53a8f55fee591e9157e5d7313a154c94703bf142a0d0c7e0b77fffaa090bdc3b"
    sha256 cellar: :any,                 ventura:        "0b5bd41496b8da12c02a823ac3033bb1d502e57015fabf6bdabc4afca82a18a8"
    sha256 cellar: :any,                 monterey:       "d4c74d4bfa2e044c9bcfdf09db29d393a50e1d6ff3ddf03399c9e92ae5b4b4e8"
    sha256 cellar: :any,                 big_sur:        "cd3a9552210f14cfb9228c4a9ff67227823b3208f9e84eb7a4c2abb37f97b320"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f280bce9bea438af3cc1a7d19f128e3ca71592eb69a1e73b0ba2601d2184820"
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
