class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2021.11.29.00.tar.gz"
  sha256 "a8d95df3fbdeb1ef4d078ee2b2883f5451a62d30526ab5571618f5d13d54406f"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "29727af941c381aa6ed789ba9c01d751c4ad9eba8e165df5bf66b81ff1296af4"
    sha256 cellar: :any,                 arm64_big_sur:  "a839a1ec9fea435766bf60ac5c984a1e5b1e109802eb26dbc32fbda47f81f92f"
    sha256 cellar: :any,                 monterey:       "18bed950a27cff5720d33274beb80f7f32fc30a60fa736fe0ba34e8f72a6e798"
    sha256 cellar: :any,                 big_sur:        "c8afa91a0347b62bb87b1b4f2b9fb9305c07daa992af81a0578baa76ce451039"
    sha256 cellar: :any,                 catalina:       "05c338b221486a90ebe649fdb94d75e4a319675fd71cd57fc07b00f49ce1bb24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5024c5e776e4cfc591014f42ba5bf985bbe60f5e6b8637ca6fa3ec31483f846d"
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
