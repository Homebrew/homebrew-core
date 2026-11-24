class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/meta/folly"
  url "https://github.com/meta/folly/archive/refs/tags/v2026.11.23.00.tar.gz"
  sha256 "44946e05dbeb6cf1d74ff590c76586e87de54fdf7e045388341b5755af8edb0b"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/meta/folly.git", branch: "main"

  bottle do
    manifest_sha256 "2758a206a6975ecfd49f4d41b746417d2b11e801fa3aafb35266c29a8fe63834"
    sha256 cellar: :any, arm64_golden_gate: "314705552081fa4d4a84a705678ca284dd57871837eb630ca85dfd93d697573e"
    sha256 cellar: :any, arm64_tahoe:       "0ba7fe1a37b49384dbb14de321151eb6af77e2f1c5cc2e308781009bc52be856"
    sha256 cellar: :any, arm64_sequoia:     "1c6354f87ceff8da427ee76f587e48197ddb31114edd601c9f73dfda603e411f"
    sha256 cellar: :any, arm64_linux:       "2e6a92915e1d88c26a86b238eb8cdde58b68cdaccbe6e97cf369f192218be6b1"
    sha256 cellar: :any, x86_64_linux:      "b1f5f71b1ee197caafbeba16a56466b54ac6afd1d69c3ce7d559679d7f2e97fb"
  end

  depends_on "cmake" => :build
  depends_on "fast_float" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "fmt"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "openssl@4"
  depends_on "snappy"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    args = %w[
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
    system ENV.cxx, "-std=c++20", "test.cc", "-I#{include}", "-L#{lib}", "-lfolly", "-o", "test"
    system "./test"
  end
end
