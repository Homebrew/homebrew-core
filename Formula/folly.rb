class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2022.03.07.00.tar.gz"
  sha256 "a52f21d5f6791160f4ff2242071f91c33c8b486687ce6345e52ef90f0ace49af"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6200acde46786f92629bb40321bcd53ef20e3e12b4b2ce01886093b740429035"
    sha256 cellar: :any,                 arm64_big_sur:  "6c57b837d34fc31bf09006dc7affbeacc19d946093b42dbe28a92bb62b47f8e6"
    sha256 cellar: :any,                 monterey:       "a916c1c8d4399fce0b9161c6abe4ac98cf74de85d722365dcec576e517cd57e0"
    sha256 cellar: :any,                 big_sur:        "ff67a93eb3e8ea66eabd07ef2a3e980ac685f5ffb2644c0de9fc6256cc79a248"
    sha256 cellar: :any,                 catalina:       "e9948b6fbc592dff8d6c7a3dfdd4dfdd4956f920116a9b38176ebdf2e6e06d6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a34b8327194f4f2927a7b9c33535f1e6cad632faf8dcd2f955eca4d02ff5b44"
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

  on_linux do
    depends_on "gcc"
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

    mkdir "_build" do
      args = std_cmake_args + %w[
        -DFOLLY_USE_JEMALLOC=OFF
      ]

      system "cmake", "..", *args, "-DBUILD_SHARED_LIBS=ON"
      system "make"
      system "make", "install"

      system "make", "clean"
      system "cmake", "..", *args, "-DBUILD_SHARED_LIBS=OFF"
      system "make"
      lib.install "libfolly.a", "folly/libfollybenchmark.a"
    end
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
