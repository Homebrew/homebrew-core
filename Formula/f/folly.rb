class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2024.04.29.00.tar.gz"
  sha256 "cf0e9d17e036f1699efe5ebd82c8b673205b1476674d4fca0b708f499a641adf"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2cf68e60a3f9b8b22eae6ce135d4dba191567d110d8fd1b9df463cd8f193ed37"
    sha256 cellar: :any,                 arm64_ventura:  "4cc78a30440b607da8f70f69494231ff9e9abc804f5b5f904280e175b26aec71"
    sha256 cellar: :any,                 arm64_monterey: "e59e85103836351747d44ca2adc511cb93d82957909215a671f94a5dd9f6f12d"
    sha256 cellar: :any,                 sonoma:         "37c9a5c484a6439cd637f988b500baf5f2853f4f3d0a7ea58e235ad55c1777c3"
    sha256 cellar: :any,                 ventura:        "5ce15fc672c9c594f214cef24529d2e224a80b0506821f4538fb0633c8fcbe36"
    sha256 cellar: :any,                 monterey:       "144fdeae91db133447817552dc7502785dd6e19ddff5e0700aba761ec1e19000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb595c24375eac45b088385adc4d44fef5999b3073fb1e3db32bcfc7c5ddefe3"
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
    system ENV.cxx, "-std=c++17", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end
