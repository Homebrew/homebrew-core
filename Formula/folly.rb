class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2023.01.30.00.tar.gz"
  sha256 "d489c25863759313d029348cdee5627c23fec12e866587aadfa544184d59ccab"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ec1e3ef5d3a935333878578e677733711bc992ecd64d1a15a3342ca7f3a8dbf2"
    sha256 cellar: :any,                 arm64_monterey: "f2ccd5a75d8bbab9ca0bdaeb1ba67e11a936861248357eed2c012a4c8b117dfe"
    sha256 cellar: :any,                 arm64_big_sur:  "dd37137d7fcf81a1804fcd05fe5e34436bfee213726cc127dccc4ecf77257d88"
    sha256 cellar: :any,                 ventura:        "092a6302286062482785422be343ad92bec824cbf03e54e275d5ea7ead58658c"
    sha256 cellar: :any,                 monterey:       "64d275b4ec83cb17868f71e490d193990259b0bd63e9534513ee8bf1a638b043"
    sha256 cellar: :any,                 big_sur:        "3e002184f9386cd9f9a8469b6febe622f48d5a6ae2aa326dfc562613bfb9f590"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bf50868695acff818974c0bd36935f92aaca645b7a89f9583e905ffca0fb74e"
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
