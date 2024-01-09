class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2024.01.08.00.tar.gz"
  sha256 "381fd227b1399a8ef9584b6e3f59b33b71643466e47cbd627dd6c0b8e8780b7b"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "91bfe19e9707fb78b63bb7447be8c43d9c36200415d17592ef6361f13581956b"
    sha256 cellar: :any,                 arm64_ventura:  "01efeafc1631173b316da1b91808cee01789b3d9d78e672a6ab571c9314444f7"
    sha256 cellar: :any,                 arm64_monterey: "ab694d5ab46f6eb901c8df83eb859bf80f55b2aebfc0ba7cd4bd623a0463b839"
    sha256 cellar: :any,                 sonoma:         "32a0b5e03e3af2ebb940747a830a6ae719c03299dd3d5d20ffa9453fbc6ca128"
    sha256 cellar: :any,                 ventura:        "758aaca58a225eefbbde3015572c10416936e921ae110871a6048dacd1d0ddf0"
    sha256 cellar: :any,                 monterey:       "40e0b1feef77412d9aefb88360c5a01c5679c75c86cbc8bd1beb2c1040473762"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d983d22f44d0c0e12c7c9096a6b527bd164020b73895a40fd82825141722119"
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
    system ENV.cxx, "-std=c++14", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end
