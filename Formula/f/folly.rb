class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2023.09.18.00.tar.gz"
  sha256 "92167187103e20b0c8b808c9f263453872caba7edf63410cda1f79e2f98828f8"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c32d9d99cd25d50782f940576e2c113f13f2db2f083996ad5a6dfe12376b9c90"
    sha256 cellar: :any,                 arm64_ventura:  "204710666d4ce2a8606d60efee71882cc84b784fa1f675e2270eeab11f1b9e00"
    sha256 cellar: :any,                 arm64_monterey: "7b9973e014b958695f55f782088c56e249ff6c144d7970e860ccd89497254c65"
    sha256 cellar: :any,                 arm64_big_sur:  "0f10ac6a9924bd689d36d8dacf9cd28ee8b730dca3514d4b21ff7d8781dbc778"
    sha256 cellar: :any,                 sonoma:         "bc94abe67619be219afd50b304e4a919da2e67895a50d99df87a019e9e7bc0a3"
    sha256 cellar: :any,                 ventura:        "c485218d7366261a04a82b737178c88b5549f95a8b2f694c2dfaa5e425c44c51"
    sha256 cellar: :any,                 monterey:       "478278b5a20c63bde7664639b518e97cb4eaeb9f580e95d1b8bfea4a698cb0e1"
    sha256 cellar: :any,                 big_sur:        "da3134881b26222a288c77e2b8027d458b5b92a16c9d7818766937095248f031"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "682f74e2414b09ff3cff7e139ef6bf1685f22939fd11d843e4d4e0757b8b1716"
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
    system ENV.cxx, "-std=c++14", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end
