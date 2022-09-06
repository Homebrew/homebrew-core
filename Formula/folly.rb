class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2022.09.26.00.tar.gz"
  sha256 "24a4cb5a4338cc3874a5e0ae13cfdc83720ce1363fc0faed1fc32c26b35fb6ec"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "72ac864d6206451a6f2f9d633d99db56a1e52e14b7606a9f158ae0e621e3ccab"
    sha256 cellar: :any,                 arm64_big_sur:  "8d54768a6b388abed5a46332c98d905657ee74f94f246219c75636838f1d46a2"
    sha256 cellar: :any,                 monterey:       "40bfdbfa9c6de0e6fd37ecf3f21998974427e96c5e135be37daa3e7e8063147c"
    sha256 cellar: :any,                 big_sur:        "a30ab254559e6d047535f844e8a2d1879ddf9734b40f8bca0ffd1e6e0b2c0fe1"
    sha256 cellar: :any,                 catalina:       "1a8666183372d72a118c9f3eaf1aca32e9852286de61972fbe4485ea5cba6a63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "124a05864872188d5b8a2070775a7238509fab2cded4cabd797675bedbc89d9e"
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
