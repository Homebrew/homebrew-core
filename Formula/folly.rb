class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2023.06.08.00.tar.gz"
  sha256 "61c3a415e46e09e01f313e1d135b7b1365251bb7885fe910385ea8a150be2554"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0c104b8c9f82c33829a241be66c87e1cffdcf96153867dab74412d95f148074a"
    sha256 cellar: :any,                 arm64_monterey: "8be395b3cd844904746f919c141c7a75f6556135e96b25e797af872f4553e3b5"
    sha256 cellar: :any,                 arm64_big_sur:  "6659202f5a0fe58276e7031622881ce8a3e8bde229fa7f8b53af340e56949b68"
    sha256 cellar: :any,                 ventura:        "4f72542b3ce589a21e3d9e3dee9c89b955869016c841939937a54afea08b009e"
    sha256 cellar: :any,                 monterey:       "1f802aa12dabfca6447d5d903d8cccae701a0d25fe3c6f9e7ca3b89e7aeb5be1"
    sha256 cellar: :any,                 big_sur:        "7edd81ab4d7d3d0ff57eb2b4902f92f953bf02772e0d1fec1d1e2033350f92b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7892a9e47392bca5011b79c42cc6e8ff29392b2c170f46c96dd83be3f7a6f5b4"
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
