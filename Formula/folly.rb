class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2021.12.27.00.tar.gz"
  sha256 "aa7f58815ff36686ca44851752fe48c3f3be468020acbed733d7475452a9c31b"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1e6b87a78d71a0a8f89214eaacb5b53da3b280dd1b8a94d02130649b18754113"
    sha256 cellar: :any,                 arm64_big_sur:  "2bf95f56f138bc6d782fd43474158a729a9c5f74b99b4aefdecddd32cebfe300"
    sha256 cellar: :any,                 monterey:       "c661e8fbb431de971ae7ab0e3efaeb0029e7e33f8ed720c7baa67eed60950411"
    sha256 cellar: :any,                 big_sur:        "655dedcb603a5e14b10c49668ce7687864e90b907616a4ec73605bd9dc43d3f0"
    sha256 cellar: :any,                 catalina:       "85f768129a2caf4957f8c5fdd3580c81bdab1d729aa17b763b06e083c6d2e32c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "101632d2a605bec4e9d3c5687946a382d2ed6aa65389a830107d40e958aa2648"
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
