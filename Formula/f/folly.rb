class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2024.07.01.00.tar.gz"
  sha256 "1fc731351f1e22cfa88a39585a80dcd56696a0613fb552b0af6c5d2ac79451bb"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "248de6661aa828ac9c628dd0afa72dca199d8f1ebcd10fafc64c7caeb2223e6f"
    sha256 cellar: :any,                 arm64_ventura:  "eaf312a0881c778e542607585fe42e4b05411e4e697ac1be86e37a1d802fb66f"
    sha256 cellar: :any,                 arm64_monterey: "2ae86fea05748a3f0acb8f3d7210fdfcd090f44dd917172b257d69e56dd9813f"
    sha256 cellar: :any,                 sonoma:         "95d8b92210a6d0a15bff43032ec2abef1494c777e8a0c915f49574af4bef5102"
    sha256 cellar: :any,                 ventura:        "94b9c619acb1b98ce3027205f4468e73630cd2b019a938f6b5bd3f48e49570f6"
    sha256 cellar: :any,                 monterey:       "f20c0aab219243d92f6fe433e36c71fd321af62d2728fe016107e79f692f6bde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d67f0918273f1dcd99ae734e8fc48f19127700f4b0830ffc03ebeaa940d3b73"
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
