class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2024.07.15.00.tar.gz"
  sha256 "4fa0549539e4c33b476678460a90f44cd6ac27d545c8075aee036c7b9512e9b8"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "66d05ac5c68d58d0a2084de632c29b6aae9170e0a538b6add4a564e582376dea"
    sha256 cellar: :any,                 arm64_ventura:  "32b65babd7ef6ad1e3d681276c76f1585a0bbce7033cbb9a76a63f281db8a1a3"
    sha256 cellar: :any,                 arm64_monterey: "5bb78927209851f34c522c237b45b37b0970508e9ca197e2e22855bef18bf761"
    sha256 cellar: :any,                 sonoma:         "9ee65bf9144fa530b5e53684ff2255f4fecac3906c615a1011e5996e07563b20"
    sha256 cellar: :any,                 ventura:        "66ca9db6d0c23ac323d1fa642c5c96d4fbfd32e1fb9316a5c74517e8a3f7a5c6"
    sha256 cellar: :any,                 monterey:       "221cef5053e90c7ac145f4ad6c28fdf943572231acd076483c4a8b73e55bd164"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "406709d9992fbfc6694b33469e4d1988f70878baf4da896690314c02291d8101"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::path::lexically_normal() const"
    EOS
  end

  fails_with gcc: "5"

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
    system ENV.cxx, "-std=c++17", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end
