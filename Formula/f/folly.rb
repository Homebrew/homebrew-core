class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2024.05.06.00.tar.gz"
  sha256 "d50418d0e9fb620def36feb50c4a8c60dd4d7dc3a5ef1acf486724f0e7a5b83e"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "024d18d018fa9f30c0bceb882cd8724bbe13eb0460fa5cc2eef50c64f0b8afcb"
    sha256 cellar: :any,                 arm64_ventura:  "b3fe57b121c18a662a44ac829f65fcf552f12cfd17639f498952ac5eec04fcf3"
    sha256 cellar: :any,                 arm64_monterey: "4a5fe588b2dd0e92975887eabe24f4299e5ce57cc0df6fa390dc9635e1bbefcf"
    sha256 cellar: :any,                 sonoma:         "d71afaae9aca3f6ee799e515698c2b0d113bd6598575693251b357be86562648"
    sha256 cellar: :any,                 ventura:        "8b3f5fb90d2566c3c2750a559af7b88665016508d844c704be67c7d8eaeaab33"
    sha256 cellar: :any,                 monterey:       "12f28c64659a555fdea41a101d81e2301c7d2ecae6a23a626ef83ca967e6c4cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ec1d77e27966f25f995afc06df44d8590118f876656a3d66382d64cbb346efe"
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
