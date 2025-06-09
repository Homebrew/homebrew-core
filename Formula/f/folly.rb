class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2025.06.09.00.tar.gz"
  sha256 "77d212dbd15208edaece07a62bf057057d44dd0f92d5ca07cbf47f526be7d5be"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "42f3451808b8806dd7c54890567a6b58e35f3bb60f716bebd3ecd947e0c279ac"
    sha256 cellar: :any,                 arm64_sonoma:  "b759d7b90e22639817fbd69ad7c74210530c2dbe7ad2e2a4e986a7c1e80e7ac1"
    sha256 cellar: :any,                 arm64_ventura: "fcabd12081cc6546dbeca89f0e19eb3b0c7c048f9d1c27dd2ab794cfdef79f66"
    sha256 cellar: :any,                 sonoma:        "3f74ecc4c30598ef839a0111213a656ad831d174acf124fe3ab1dc44aa875548"
    sha256 cellar: :any,                 ventura:       "dd4b6854f41cd3c2aae227f4a62ccf0e790a480733a7f5f5cd70b290d1761c2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82148e8b1a13a57ab34c08305faf7829c77db288fd2176e31ae1ed08f8214730"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "504b8795211dcf1d6d92cc481a5df9db506ab0c80f3f41d3364230efc087d44f"
  end

  depends_on "cmake" => :build
  depends_on "fast_float" => :build
  depends_on "pkgconf" => :build
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
    cause <<~EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::path::lexically_normal() const"
    EOS
  end

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

    (testpath/"test.cc").write <<~CPP
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
    CPP
    system ENV.cxx, "-std=c++17", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end
