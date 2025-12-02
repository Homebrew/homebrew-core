class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2025.11.10.00.tar.gz"
  sha256 "62fde99e074f7402938c29cf6faff7fcceac2524956ab339f13946efa3c334b0"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "60cd2d520d0726852be0eb50d3c8f5d266e66b5be087b8f74956bd3c0fdb12e7"
    sha256 cellar: :any,                 arm64_sequoia: "92d89a7f47fba4e9d604dcca68dc0d5eba8ef44973513b9e2d3c9fd069000d1f"
    sha256 cellar: :any,                 arm64_sonoma:  "d1c7891942e9003304954eb72495fa14afbbb32d20ffbd18dda82d17de3cbada"
    sha256 cellar: :any,                 sonoma:        "cd113e9c6c5faf028949593d53f7f17a962bfab7fd7098bc468bde8cd5f5b571"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92bfc488fb1f37f9d7cfbab7ea88a665845f1231e4b837a08e7fc3fced897b7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9edadcb893ebe431f63f86d321008382a67d2bea472beb080cc1958eae07cf92"
  end

  depends_on "cmake" => :build
  depends_on "fast_float" => :build
  depends_on "pkgconf" => :build
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

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    # https://github.com/facebook/folly/issues/1545
    cause <<~EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::path::lexically_normal() const"
    EOS
  end

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

    (testpath/"test.cc").write <<~CPP
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
    CPP
    system ENV.cxx, "-std=c++17", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end
