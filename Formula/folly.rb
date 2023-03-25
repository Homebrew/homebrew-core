class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2023.03.20.00.tar.gz"
  sha256 "f28d6c345db74b61392084d01852ee802dd985ccec16e9196c25a8e06a625e01"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7b415afe8e25bfea1a15ee4e291b5ed7a5decb2a5fb418e81a9930f991c14e98"
    sha256 cellar: :any,                 arm64_monterey: "5f0fe5d72fe54974da7b54dde4c26dabe07b6100942f9eb02f0315eadc6b1c05"
    sha256 cellar: :any,                 arm64_big_sur:  "cbe6b34f751a3beedcfd6cbd67d7dd4e021fe1e9dde6afe0d4af392f6a31c2c1"
    sha256 cellar: :any,                 ventura:        "31fc19942d7d3c6abc6f5e24259bd9842d8a8ae1240d2b8c384786acf9eb61f4"
    sha256 cellar: :any,                 monterey:       "854c4dfe665d3777fcf535c14390701e7f48a92c81d090df06b4465f8380774e"
    sha256 cellar: :any,                 big_sur:        "a24835ac60c3a291615b7135ad3a216d9cf02fa73d181dee4efafa63eb2dadee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7c7f87858c5dea61e8d87f61c15ba0478182ec2d130a80f622313b5dca3cfdf"
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
