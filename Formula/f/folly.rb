class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  license "Apache-2.0"
  revision 1
  compatibility_version 1
  head "https://github.com/facebook/folly.git", branch: "main"

  stable do
    url "https://github.com/facebook/folly/archive/refs/tags/v2026.10.05.00.tar.gz"
    sha256 "403a1180bb6ade75182c8609929463cbb14bfe63696e39ab86bd691446fe76ec"

    # Apply open PR to support OpenSSL 4
    patch do
      url "https://github.com/facebook/folly/commit/e3330eaa1edef120fe13911fa259152c8b1f8734.patch?full_index=1"
      sha256 "d85da885a98a12d73e6c970aa62f18ad8db8a1653bfd0eee722f3aee2de1c4e2"
      type :unofficial
      resolves "https://github.com/facebook/folly/pull/2706"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d723cf8a89b321d8c7ab3b5be4c2cf413f1c5a4f85d25ec7613c010214b0358e"
    sha256 cellar: :any, arm64_tahoe:       "d0951b7a2c957abf9926016794531b7f6370f808ad3cfd61e7f3e5545a2c7aab"
    sha256 cellar: :any, arm64_sequoia:     "51d4ff47843ba64dac6c97d7b24658ab4178d2b0bcfe8c7f446f6c29b32e9514"
    sha256 cellar: :any, arm64_linux:       "d03fb0e44e431e3e68ce1a7e4c77f252f43bf39b324b79ba075976a43d88af48"
    sha256 cellar: :any, x86_64_linux:      "9860ac085d7fa9057ba2113e572af2ffe396881ed9ec0f45cce05f8585538fa2"
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
  depends_on "openssl@4"
  depends_on "snappy"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
