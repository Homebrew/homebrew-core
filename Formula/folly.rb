class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2022.12.05.00.tar.gz"
  sha256 "1f2327279ee1bca13eb9e773a8ec184d4b2940d8f802fc83e7b395c1f7f04b8c"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1e3cbd778f73f7c44996645c35889bb3b0729da1d6b211aed5e20b127d643d3f"
    sha256 cellar: :any,                 arm64_monterey: "dc98b1cab1c7f6625f8ec55c4906fbd04885f761d9c4095fe7276b7543689a7d"
    sha256 cellar: :any,                 arm64_big_sur:  "3aaab5eef1de5b999df170d329b09d58003a424ce502e4c2ada82aa9bedea772"
    sha256 cellar: :any,                 ventura:        "628682f0bda7ba3f5eb02d590da0fe111841ee6bbf6a3138a5b6c7c03d60657f"
    sha256 cellar: :any,                 monterey:       "23827790d5700a78f689f3c9e34746d21e0ce1f3c2529aca443e6a1787842683"
    sha256 cellar: :any,                 big_sur:        "231745047df8478c0bcafd141642fc354fa9534c14ee8c8792fdea75c48210dc"
    sha256 cellar: :any,                 catalina:       "5a2e81fbfb4dc8a91dbc01f436a60b7290e18df79e8726ce408d93549ab78a9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3a9342ecd28416e7afa53df36d6a0d21f4ab65f47d348034e0ed6552262c440"
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
