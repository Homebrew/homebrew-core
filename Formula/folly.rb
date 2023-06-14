class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2023.06.12.00.tar.gz"
  sha256 "cb7d075f5610dcc50084d727ee675daad51733b049f0b07cc112b160e468599d"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "491facfb27c8194c013a02d1aba9f5570d7a635fe6c4be4c6cd21254efbebf6e"
    sha256 cellar: :any,                 arm64_monterey: "d2f6dd7271d5a12e80338bc83231c6d336303e377236e85ddc3dc08c304d3181"
    sha256 cellar: :any,                 arm64_big_sur:  "15d3246c3c19af923136371eb253e3b68b48f23d5d062ca681a73d0b24e7210f"
    sha256 cellar: :any,                 ventura:        "35e8860cb576ac737113d4e2cf6f8c365271ef1d4bb61e1336ba844b9e04ce0d"
    sha256 cellar: :any,                 monterey:       "a50c5330e90ef6e9a3cc5bd6427a0ce7760345f04aed2190294d35e39e2f7706"
    sha256 cellar: :any,                 big_sur:        "185393cf0222d6310d06ca6aaa47437bc0d21c65de7b27a54c1e72a88f7c1c05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "224d720a2e24d66810a4b34c8146e5b2fbfd39a9d492be8d8ea22b2ca339a2bc"
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
