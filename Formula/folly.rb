class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2023.01.16.00.tar.gz"
  sha256 "b5d9b6d5833a6f149819cc828ec0f569f1edc88fd79344c642d2606d58cee130"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d3d2f7f1a6ebbd8f7cf4219049ff997c13278e9eaf809bf3140e3ffbc144517b"
    sha256 cellar: :any,                 arm64_monterey: "8070e7b8bfa44980f5593163c5b9c15d91d7bd28fa2113069c23ae6464b11ead"
    sha256 cellar: :any,                 arm64_big_sur:  "fd817d2899b87c2ef9fa0e352727167438bd082c80be320f5871d2cbdbd2c93a"
    sha256 cellar: :any,                 ventura:        "cc0340b0b87a6f33cdefbfcf26c6ce8ab0a7265739099bb56659cf962e92b18c"
    sha256 cellar: :any,                 monterey:       "e3edf7898e9bc27fe30f8470afd432827ee671d30b68f3b798adda145dd89b11"
    sha256 cellar: :any,                 big_sur:        "36d729bd41d47b16097e67d58be7043f8a57b5b83b010c987364ba1ec527413f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d18cde224aa2594905d04b0e91fc754b50a2e21d60e2c31bed2e473c49946e29"
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
