class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/meta/folly"
  url "https://github.com/meta/folly/archive/refs/tags/v2026.10.26.00.tar.gz"
  sha256 "b47fe04b804adfb51c65cda6b171505e67b9d1d69621106e54697821d1bf7ebc"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/meta/folly.git", branch: "main"

  bottle do
    rebuild 1
    manifest_sha256 "134163c630d9030af91b1293836a338db559d542f3ff4842b2a74d0c1471cdd0"
    sha256 cellar: :any, arm64_golden_gate: "f1e5a953f5a979c26efd422c2ece1319d59ee03c5493625825764a557d2dbde4"
    sha256 cellar: :any, arm64_tahoe:       "4ec0324e8bbd2b3190693f98b154c7e1f70ec4802df230d9fff099ebd3db3383"
    sha256 cellar: :any, arm64_sequoia:     "4999e0f17712499bf619bd5fdfa645630293f9a5da1470d9dcf819b19d76ff26"
    sha256 cellar: :any, arm64_linux:       "ad57686fcf6fbca1f3976a9205496a62d489e862dde57c50d72dfefb459d13ae"
    sha256 cellar: :any, x86_64_linux:      "38be34f75e584ebc64a8dcdd68fb448a86e20878149cc95b5653e7ccdf84114a"
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
