class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2022.12.12.00.tar.gz"
  sha256 "14b083e829306f65c2981e37948b3c4b9331640fa88e10500458b825c1237edd"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "40736fcd3b6827cfa431346a50b36155ab15a5df915c71d7f48031c67037affb"
    sha256 cellar: :any,                 arm64_monterey: "17d0dcdc2f7b060311972043a071bc6096ec37fa734a5081e4b08aa758bcedc9"
    sha256 cellar: :any,                 arm64_big_sur:  "d8b8a3a1b191f00fa978c0a330bff46d122bf019119320258d51572455383d8c"
    sha256 cellar: :any,                 ventura:        "edb34551890496b52de37de4ebef057f705195703f578ea39a6d26a0147330be"
    sha256 cellar: :any,                 monterey:       "a710d2b0949e9a2d25ef6cc54dc1fb84ffa6360d222c4aab6f02f0491a347b92"
    sha256 cellar: :any,                 big_sur:        "4dfa250593cfbbdffc2f8281528307186b51a3113aa5eff6e43697af0291ce45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a35e0ebd8044933d6c2597a34ecba52be95f2a4478b8c3d37776296b78907b2"
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
