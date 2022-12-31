class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2023.01.02.00.tar.gz"
  sha256 "3d9798dae415ac2beb437f7a1054dcf4e3de9f2c100bb55a486a147a8978bf74"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "20501317964330c0389b0540611763c71708574346ae4d3c7fd7841289bf74bd"
    sha256 cellar: :any,                 arm64_monterey: "cd1f94174337dc13641e0954999bfc3180ce2bce1709ad3ca5ae294adcb18aa9"
    sha256 cellar: :any,                 arm64_big_sur:  "a482282970b2eb2d8709a18caba54f3fd040884743b103fe429b0137001adb5e"
    sha256 cellar: :any,                 ventura:        "3cbf9248f8a188755113b12bef749c13b1fd2cda020ced22f24df3615047fd8b"
    sha256 cellar: :any,                 monterey:       "65dead7bac3bf6e9f782610e8faecb16932384e68b8e035279a08b11cda0d347"
    sha256 cellar: :any,                 big_sur:        "463d5d1cb1e99a60f8a381b64d1c0ffccdf915aff778897c7887e809c916252f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be09cebe74866ee92260a4aaf12ac715dfcf0f9ecf48bd3715e244180e1ce1b5"
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
