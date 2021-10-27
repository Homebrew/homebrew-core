class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2021.10.18.00.tar.gz"
  sha256 "916536aef4cf2b72ed98293ddbe6522bd82eb556423c70ab1ca9aa5e26eab462"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5d723649bc1db9428249f7c984cde30a9a18b59f699f2b4d8c208d7960029839"
    sha256 cellar: :any,                 arm64_big_sur:  "8b3ae5af394cbe24b65f390a86e55718c1dd4d159453f3d6b2e106a2668c25cf"
    sha256 cellar: :any,                 monterey:       "0440d0ddabdc678977308031cfa2df901b2a081bfae6ca703942b88abe78c1aa"
    sha256 cellar: :any,                 big_sur:        "510f0fa53eeb9aa10792deb556eaf572fb095eb372e22b80a7a577ca0d2b848e"
    sha256 cellar: :any,                 catalina:       "29ad2fc01ea2ec30961aec039b389e085f4082bed478e9750dcd21a5c794b7c5"
    sha256 cellar: :any,                 mojave:         "e115b9ff3e45f4c453683976b9256e3d1005da0335655c5aacc08edfb46a4d23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "932352b381e90f7b9f03a7860eb7fcab10d276db6c4c8d7251a0d93938ef7d86"
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
