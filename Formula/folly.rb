class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2023.04.17.00.tar.gz"
  sha256 "356fa51aeeca51e0e068229892d1a21d23014601450382af7c3af6f93feae9a6"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5eb4855015c5b8a3006345d1951026a668b320462b864e807d7697b462e51828"
    sha256 cellar: :any,                 arm64_monterey: "f679895dad6db64dcaa12b679124b12b630726a61b8b436bb2a8fb8539562998"
    sha256 cellar: :any,                 arm64_big_sur:  "36655f41a29aad67ee98e80c849dcf8fc6e2bcb4460fdb32e2fe9fbcf565afd8"
    sha256 cellar: :any,                 ventura:        "4c5e51581e0c321e0e03cff48e91215d699e86518343d8a34e896d9d38f62e9d"
    sha256 cellar: :any,                 monterey:       "6aa19e7cf6661cbf8188dbec41cff543f1383c05e4136de7ae4b41df109937b8"
    sha256 cellar: :any,                 big_sur:        "454580dc5b1d8400e7cb0d07a6cad66d182568adbceb5a5fd09f400f8424453b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "184a2a95970d0fddd4bb674ab9bc2e8c41f0b2ccf5de0e420e45eec34f9ba96b"
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
