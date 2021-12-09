class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2021.12.06.00.tar.gz"
  sha256 "ef40cd400672ee8b784547bee964c1d2964504cadebfa0b8933128545de00961"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a78745eb4a57c63f25f76f89ae5bdea2fed0ddacebbc0b65ed34154fdb6d592f"
    sha256 cellar: :any,                 arm64_big_sur:  "6ceafb076283b84796ae6fdffab1042eb297d664753a2b90618bb7b35bc5cba7"
    sha256 cellar: :any,                 monterey:       "186dc7b75183a31f94b38679aa0e40277f3493ca07939afae74dee9c348cbe89"
    sha256 cellar: :any,                 big_sur:        "09ead84368e62120026ee786f4d2f338e1aa820183ea34e8290b54ebf8d1597c"
    sha256 cellar: :any,                 catalina:       "073e6780f9a3c31ee36182a089cadcbfed0b4585f96dc187931019ab6eb5318e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f54b38bafe562df4e6f6d68e75793045f42b16bb2fe124798a9cd79244ca4624"
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
