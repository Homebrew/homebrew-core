class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2023.02.20.00.tar.gz"
  sha256 "fba814d7cf620e58d803b03673950f0b38e43e7530f0285c3b2bf671e337a9d1"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "73f36e24cb83ab5b88e30788d8f53421b4b9f81a48a54234e2687cfb799541c5"
    sha256 cellar: :any,                 arm64_monterey: "01f25bd80f523eb83fdc658a0499b2e5f706bfdb258d3e90fbc4a9b0ea129f9b"
    sha256 cellar: :any,                 arm64_big_sur:  "69137b8c5735309bc046a3942b5b19737f6e8a22d2e8ba43ef01140f1b23d6ff"
    sha256 cellar: :any,                 ventura:        "0621af156e6fbdc3996a62f3d5f07cccaa79d3c082f5f186c94e5513529d1588"
    sha256 cellar: :any,                 monterey:       "2d64d85e8537c172c2c71113c678c9ae41c7dea560f6911dc2e6ac97dbd59f32"
    sha256 cellar: :any,                 big_sur:        "8a8dabda3ad5fca6ab51882b8f8b514d00a642a68fa5e1b746b652e7f4942b13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7df0726cb587dcb101b8b98c0cf0794da010a515e1b20ccbcd168e93ae8727af"
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
