class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2022.11.07.00.tar.gz"
  sha256 "ecd1df58cc20363b6d57434441123c692a29a6494a1788e1f210aad8981a636c"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "150839264de28135590719e4b76334e6de1e0b6899ba2918010370afd878387c"
    sha256 cellar: :any,                 arm64_monterey: "ad81b1e7e587ded74bb6687a997c6d0550629daf3089050000c1d857911e8748"
    sha256 cellar: :any,                 arm64_big_sur:  "4e47268711e230e9922b87edc92b519f1fc6d6d1f5f1f6790c756744f8f55a3f"
    sha256 cellar: :any,                 monterey:       "317a5da483313f4740572c7ac3b39a1412210e9001c00ab33a52b60c61290329"
    sha256 cellar: :any,                 big_sur:        "10a5f6780d486f6ca2db2a8ce61f78e739f3bd5e9f83e59d27c873b42523b3e2"
    sha256 cellar: :any,                 catalina:       "433fcd3d6fc73f5f7998188414de2f0d815fe8f7aac159cd0b06d42e8666540c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f4825fa302fcb5fe32914acd630d9137d365363b01ef5b8502c640f6461e0b4"
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
