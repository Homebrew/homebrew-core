class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2023.10.09.00.tar.gz"
  sha256 "682b54ba10e36bc4c9bee0a08fd71981584c73e066eb5e573669404cdce0ce66"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a670919ce540b8df3f78e93b76a0953584698d83aa812c41a5b1d2c25d488241"
    sha256 cellar: :any,                 arm64_ventura:  "e4585eca8786ec9a9b728e7f60f0e375d6fb7f11edf6bd0401bc4597518cc4d5"
    sha256 cellar: :any,                 arm64_monterey: "63a58e2ea138ac18dc6311a3cd4b8c453a6b388b18454969525238b0b2566c2e"
    sha256 cellar: :any,                 sonoma:         "3acc0eb35ce646e23a8d4c9485fe517435dc424230e7f9ead42fc4b67acabe05"
    sha256 cellar: :any,                 ventura:        "dc109e21a35ca13ca077e4606a87e3e911601b207d5f3c6aa9aa486d2415485a"
    sha256 cellar: :any,                 monterey:       "f3e736045eebc418141457e2b17d264821413a4258db9e1f4c8ad2dfa9419c89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d2af45a7be6826fc83926a297051a5acd0cb38a873d57db999709822662e2ee"
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
