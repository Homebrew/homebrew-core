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
    sha256 cellar: :any, arm64_golden_gate: "dcf618295c85ada758e841e86ba82139386820bbcc4d1bb42368c55b20b283a5"
    sha256 cellar: :any, arm64_tahoe:       "da891e47c4887b54886c512cbcaafb984f58b0e907a4c6afe8aa34cb5124d8f3"
    sha256 cellar: :any, arm64_sequoia:     "c548152b7f7114bda4ce5496858769bc79152992151e02fe3b6cf372b5a8256a"
    sha256 cellar: :any, arm64_linux:       "2f3ba187209c93b42e56122f0e39ab7a9a3c0f707f7caff990f751de7b49508b"
    sha256 cellar: :any, x86_64_linux:      "49c717ba90a1a1877b2b7c8e7d8210f9681ce1b53d33a39ab6c1da3a44eaffe4"
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
