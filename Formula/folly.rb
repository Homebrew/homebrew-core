class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2022.10.24.00.tar.gz"
  sha256 "c3edcf7c4b20d48216d2bd2844472d52925f7ab193e2ad160e4e33bcda9f5aa9"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b8a8fc69cca512a0d50c74dd549cc667c7cde4d13d71552e3f80e651fb1489fd"
    sha256 cellar: :any,                 arm64_monterey: "785befd9682b6a8e77c5efd979c4a8e111eb9d7991de321b0b942c7526e5d68a"
    sha256 cellar: :any,                 arm64_big_sur:  "4de478a164903edef6d38856aec62e8fe3a2391fd03462a659c43d68eee0fe7a"
    sha256 cellar: :any,                 monterey:       "7086a16c98944aae9b4ba35fcf7b4b0c02bfc4810e3f73bc0c8dec5ee37ad9c6"
    sha256 cellar: :any,                 big_sur:        "5c1ac261b04dc4e65521756ea81dad5fa5565040a9af43b34f15bc2ba27b19d4"
    sha256 cellar: :any,                 catalina:       "8af5921c3e204c36ad055115e53a9428025fcc7ca26113c72d5dcba1326c220f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1538c22c414380092058512d81c1a10d1e80d9a9183cf9311b5ade9f4707f9d2"
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
