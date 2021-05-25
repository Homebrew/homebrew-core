class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2021.05.24.00.tar.gz"
  sha256 "5c0f64ed80ca8230bb313b9fd31afc833f16827526fbc3673cb3b97572170317"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/folly.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "00f2aebe529296354d00e81c8ce4b1f6f72b7481177a7b3667ee0655d1e4ebad"
    sha256 cellar: :any, big_sur:       "a12a9e1ce727a70f6d930a1b736813343bc13ca6fa58362e29fe3c550668a6f8"
    sha256 cellar: :any, catalina:      "89e65fc27b49eab1ab458f97926dde72aa71b4dbf6227693400535aaa269c04e"
    sha256 cellar: :any, mojave:        "999e96f2746f62a41091b524a32169da419fea9441af8f1015553369a58cd705"
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

  def install
    on_macos do
      ENV.llvm_clang if DevelopmentTools.clang_build_version <= 1100
    end

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
    on_macos { ENV.clang }

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
