class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2022.12.26.00.tar.gz"
  sha256 "43de1d3d88f03d031c5ad742ef862397671dd89cd4dbf127f4e23f50681b8d82"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "334947e21d9e0e3f00b9fa11469b85f28fe11d776d77cb5e5f197bf90be38123"
    sha256 cellar: :any,                 arm64_monterey: "837afc810597791674f719a29380967e80ad3e9cef4c6c5a55e0aaecb5e60570"
    sha256 cellar: :any,                 arm64_big_sur:  "6bba59873601f52c131f3d0961466e93fee58f21e412cc2cbdf80bece541b9df"
    sha256 cellar: :any,                 ventura:        "b0ccbf93b01dad02fd76a070619ab748d9b8563f2c0f0b9cb60cf8562e2543d9"
    sha256 cellar: :any,                 monterey:       "bdeb3c3b303300e0d832260a5261a3ce9adfa1352615a54af4156da47a65079f"
    sha256 cellar: :any,                 big_sur:        "964cbea1d4f49940de726742836c87f0dcd37b693107b88f8fedb7ed06379be0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d79350834f0fa9e086edd0f700de88efc63fd42aeb44e4f30b541cd620d7266"
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
