class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2024.03.25.00.tar.gz"
  sha256 "1845b40ef600d4f3c1a6d2065fa5ceeb15c2e08603d287a3a3d0e32482f86064"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fd06c76ec6c0cb6f1e7133023122f1f391baf6b4d2e44fc6a60261e6ac33c08b"
    sha256 cellar: :any,                 arm64_ventura:  "d696ba797f34149ce68189577cc3881448f53aa615390545c019be4f5a1a0e14"
    sha256 cellar: :any,                 arm64_monterey: "886a2d0518faab45e7dcd7fcc56024c06dcc5cf48b7bd2d94e9e5294d833275e"
    sha256 cellar: :any,                 sonoma:         "32a490bc896304066e521a462d1bae3d025d759407273b09d57ae719cc331408"
    sha256 cellar: :any,                 ventura:        "7af3896342c9cd1f41709ed26a57153c2b8324544a9a47cbe0e6216d59c219ea"
    sha256 cellar: :any,                 monterey:       "41cec5342d1e6f6333d9ce8c5ba3c5331b46ecdfa7a8061a919733e93372a46e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c2042c3889fb1bf8f81f324a6cfea79b02a9ce7a613404657de70c8a4df7d6c"
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
