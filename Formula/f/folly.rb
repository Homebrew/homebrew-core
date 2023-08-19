class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2023.08.14.00.tar.gz"
  sha256 "63b0abc6860e91651484937fbb6e90a05dbf48b30133b56846e5e6b9d13c396c"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0377ab650cb478112b0db8e0690792e14408fa871cc42b8d1aedf40384026b5b"
    sha256 cellar: :any,                 arm64_monterey: "4caa668bf8be8c8d9cc25e7d2b9fb9c2de78da7f550560ff7aeadb5a84fd419f"
    sha256 cellar: :any,                 arm64_big_sur:  "d62be5ffc65d361ff82ee3ef6c665748793d2e882b02726d5035dd68ece722f3"
    sha256 cellar: :any,                 ventura:        "f5c21316be7c6c7458c00f1f85b0def59d522c01679f7132baa1e28de591ad37"
    sha256 cellar: :any,                 monterey:       "5c8417bbf1c8d3c2023cb06793acc8b5bb66c964b5d6a1a864fcc78fb0c90cac"
    sha256 cellar: :any,                 big_sur:        "cb833e3eac6f5fad1fbc5a4d2690d496e864a95a15af1c8104eb68256a16486f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "854e73e7f47b12b5c169579201757e48b8bdf62d68a2a102afb5637e2e77be9b"
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
