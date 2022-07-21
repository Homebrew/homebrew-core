class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  stable do
    url "https://github.com/facebook/folly/archive/v2022.08.08.00.tar.gz"
    sha256 "ad27468c3c8dddacd592baa688b5d9b0a1de30c8f57e959fb88ba68a231f853d"

    # Fix CMake bugs for x86_64 builds. Remove in the next release.
    patch do
      url "https://github.com/facebook/folly/commit/10fc2e449038d9ffda5cd53999edb9875c4cb151.patch?full_index=1"
      sha256 "23b7a26530d83b391a5e587e5ba6c88c2831dc516b2438a99eb27c6d1b9e7e1d"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "03f9148ba3607548d9a4607f63e868d9353cfade1a3e5c2a198e832ec17747d4"
    sha256 cellar: :any,                 arm64_big_sur:  "67036d5d4eb0b321c37a789ce604f1f0f2b641b5e88d19e810b79c73f11f050d"
    sha256 cellar: :any,                 monterey:       "6462097eaf7026ddbe101e01ff03f0d1e3fc393178b87f80b21a11de6358077f"
    sha256 cellar: :any,                 big_sur:        "863ade220942581d663f5d62f547ee825b85bac65ce54a36ddc22584d526a0fb"
    sha256 cellar: :any,                 catalina:       "5e1e1cb25d7590ed3aa3c3ce8558065c3cf89061a04020aa349448760b143308"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86dfe421565dfdbaef318c48b40bfb3eb339af8460ca3e3a8a3f87ed89ee2b35"
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
