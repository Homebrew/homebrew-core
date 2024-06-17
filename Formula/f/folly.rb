class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2024.06.10.00.tar.gz"
  sha256 "ecba8615fd4faab670ddb5105f6e374490d6dafd982673ef07cc677eed058a78"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c620ab43dd8a484a1bcf07443601bcb7a4acfcb1b3d21d1c0c3a65baba776e83"
    sha256 cellar: :any,                 arm64_ventura:  "ddb5247206f0b41a5ef111ac5c4279482219c3f3ff3856aa87da1f3004439b28"
    sha256 cellar: :any,                 arm64_monterey: "143da10d8bd84ba34af9a88f771c0a836f3ea5fc7b5431043c597a0aaff36d56"
    sha256 cellar: :any,                 sonoma:         "abd51a0970604c57b5400eb4975e1df7f0ab6fdfafce71de339209ae25cac3c4"
    sha256 cellar: :any,                 ventura:        "900a54ebff1bca000b04cd9b86067d33dfb3ded817c28139c84e22967c2fa400"
    sha256 cellar: :any,                 monterey:       "7f3fa60131e77f50105bbc0fc981bf5ee3a39dc7e13a795ef4c87b83f9e677d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "743fff19cb84ebfd38bb946eec817a480bf4ae4835280a782b5de9d987d5c52c"
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

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

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
