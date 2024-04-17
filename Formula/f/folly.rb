class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2024.04.15.00.tar.gz"
  sha256 "3d59eb2acdeec40d662cd48fc37c5f3888f1dbc784064365dda223d67958ee26"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c8c669a3526fffbfcf61524cc49dd3245e74dff7860f45da1500c28e33d8a5cd"
    sha256 cellar: :any,                 arm64_ventura:  "87842ce3b31330d3472aceaf2a9bf648c8f301445ba445221483a85845f6f1cc"
    sha256 cellar: :any,                 arm64_monterey: "c65ba459743eb0781a36b48faf55c432417cbdfaf2c833aaa361f4b37686a21b"
    sha256 cellar: :any,                 sonoma:         "a71ee5171f503db8ce20de6272005d8e0bdf2b9e4a9404fcf3aaf7c5a634262c"
    sha256 cellar: :any,                 ventura:        "581c5ce1d587a8aec27e86a866a10f53b2dbd01657a39ee548b6703a79f7aaca"
    sha256 cellar: :any,                 monterey:       "e96be58446fa4ce3d0701b27755cb8227d055752e4f0f068db6d703535399616"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0f58c4321f6b10de4ddca27d5f1372af9c719e5beca9d32c794391451d47a70"
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
