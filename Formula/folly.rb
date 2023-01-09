class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2023.01.09.00.tar.gz"
  sha256 "3c3237f14f38fda2b24a495b73c9ae8fd29c54d1ba7ee3636471dc9dc32f638f"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6f90ed18ccd02fd9b96b83e566a7d41abe74537b062fc2e689a77b000215a1ba"
    sha256 cellar: :any,                 arm64_monterey: "878dd13fcc4a90de48695b88003559f80bf0473e27f174779b62dfdf84402496"
    sha256 cellar: :any,                 arm64_big_sur:  "4e708e4c92343ea9a948b60fd01ef921e6f6403acf63fcf35bd2a1bc492c306d"
    sha256 cellar: :any,                 ventura:        "2ebd38da5e0f63fdd50b8bc31ab83a44315d3e629086ac5fb5bfe535c54fe324"
    sha256 cellar: :any,                 monterey:       "871d1d62e17ac5ff1e5573c9594c40575a0be310ce42d98a77bcd574c1d679d8"
    sha256 cellar: :any,                 big_sur:        "950df19d4d3cc9b5391845b52b25e0c01a90aec0fd54019b0848a1f1a4b0d1c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e0c5049dde93d3ce8158991604fed8f93b1c207aff8f7fd39d31de347968ad3"
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
