class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2022.11.28.00.tar.gz"
  sha256 "03ab9b889fca5b31064900e817fdcaecefa6dd1b2c36a1fd8dbd4a003cb6f816"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "77297f311e297514b906a68b09d88359d575b697c109f3597c49032fc10747c7"
    sha256 cellar: :any,                 arm64_monterey: "bcbe28db104519234f755f230cfbb6b03606f7997676d8088fa1f3cfba1bbafb"
    sha256 cellar: :any,                 arm64_big_sur:  "0d538a8fc326d2662798fbe86dd66103c7422a04387ffd42cfeff919ca5fb4fc"
    sha256 cellar: :any,                 ventura:        "f22988eb447f972859e712a261fc19d931fec4bdb3dfc93a12e5d5a2959ae159"
    sha256 cellar: :any,                 monterey:       "49b8994a0848131751c8880bbd6804edec25d77cb16dc2d6330c9bae8da51860"
    sha256 cellar: :any,                 big_sur:        "21eb411b6f0435113e22d896a8314ae343ee0d62479ad21405d0154626dd5bd6"
    sha256 cellar: :any,                 catalina:       "4a12118cc67197ae3fe9991daa75859819c0c7c7096c9a6b979eb6946b27dbc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f58e133706c739d68006a7e573bac901d47a765c87065f9d03d2dd1681229d9"
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
