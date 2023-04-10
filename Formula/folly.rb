class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2023.04.10.00.tar.gz"
  sha256 "79deee04be669ed45d35534ffd952a7f7ec397519110dc2acafb7e2f230b384a"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7964ac22ba32c535870f19bdb30ece847dda7d1ce11516e11d95df554b3a0da9"
    sha256 cellar: :any,                 arm64_monterey: "fc1062f0923a29b9d230e9aef3845938257421b7599492061085598e2be7b6ac"
    sha256 cellar: :any,                 arm64_big_sur:  "54f8186c9bbe857ab15ba90c765b95d3834a3cd30c0e324a51e75e08d7d53d48"
    sha256 cellar: :any,                 ventura:        "8f5ef5b52836062d79146d6735e404992054b76fc21d20fcad2c55e8ffa5ab90"
    sha256 cellar: :any,                 monterey:       "e4646f15dab6fa4677689296b0a1ba7c0ff896cc03728ed67f640c6e9b18ab01"
    sha256 cellar: :any,                 big_sur:        "4b35de354b7b477065993d7f70d7015552d8f9db98b7c5b9ca911772a7699363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61d3841d0da0853d80d92f08b847c8378ffd97b165d9d7c6e42292e8effb987d"
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
