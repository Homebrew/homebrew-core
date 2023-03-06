class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2023.03.06.00.tar.gz"
  sha256 "04cee9d8a651a4718f359957aceb345bf546c9ac666c249d609e6611f505f78c"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "da5ccd1828cde4a2f3879e4e565b1ce935f06c2003bf43c383df2c44a23e8781"
    sha256 cellar: :any,                 arm64_monterey: "553eec815960643dee49bd9ee9841d16d0bdadead41f889ab30ad39956446ec8"
    sha256 cellar: :any,                 arm64_big_sur:  "51c228cc6dd1315c9843bda21afb344146ea74a676219ad9756afd1e111d3175"
    sha256 cellar: :any,                 ventura:        "f7a1d73f99f680cddc292d3b61223e7e3d6baba7616c95da06d4bbc2b4c1582b"
    sha256 cellar: :any,                 monterey:       "1f1c5b024c30802a4294ee8b353bab2c09bad8f6fb19845aa71a46332f1710b0"
    sha256 cellar: :any,                 big_sur:        "d3f9e68a6271d64df00c68424a359a0c8633672af89288ee069de11755d9a608"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b4b93d07170b7855a15444fca9f5bf227c8e5d35f1444ec4db2666fd9e8f33f"
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
