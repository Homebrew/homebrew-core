class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2023.01.23.00.tar.gz"
  sha256 "f646641ef58e9b0ada44ba4a96c0cb8f811df4ef661a03e2db0b82177654906d"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dee5239ba12f47494cdb8e3fd330886657786f796247201d14fb935a8dabf9a7"
    sha256 cellar: :any,                 arm64_monterey: "eb608996aebd6834188f39d864c7b40b32aa70d120511712f26129e4cdee789c"
    sha256 cellar: :any,                 arm64_big_sur:  "5cf000f7d56a9c5937bc767595d2f701aac6deb8e8522c6363c2eb315e4fc578"
    sha256 cellar: :any,                 ventura:        "f20818259bfb3eba523bd3831920edeff812cf27e7da28bd16ca6ecf348b8756"
    sha256 cellar: :any,                 monterey:       "1d89af803ab53e15fd9b816f94238922a6df3246c7bc20eb1cb3813d6f1ad1fc"
    sha256 cellar: :any,                 big_sur:        "a58c9317bcee67c69cef8c440036ed6c3980a2a79bcb9dee995fba3354613034"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ad1be0e40be74d701b0b9ee31f1c472223b07080a66cac4e6ae287eedca9ca7"
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
