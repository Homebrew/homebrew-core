class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2022.06.27.00.tar.gz"
  sha256 "cf0d1c637527fc5f2191ddb0f6092f1ba2bb825aebbe2529c49ed904678de510"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d24f318bb0e98edc643ab4dcd64cbb22f3c96491a649cb46fbac4cebd25838d4"
    sha256 cellar: :any,                 arm64_big_sur:  "2dbc92fc8a22d78483cfd0492034dd9c6cabac70d6f3b7e40d0202353c514a98"
    sha256 cellar: :any,                 monterey:       "7d5b2d25dc0968afcf9cbd4ac3d133d9fb15543c4b8589cf27dd410c09ca0772"
    sha256 cellar: :any,                 big_sur:        "33415d1225dd7c52126416dc194659c6ef4e68761bb9aa3cfa46e9dd1fe9fd9d"
    sha256 cellar: :any,                 catalina:       "2c413e5fa9627dbd3489178f9611c506ce9a794b154205a3625a9038bba676b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90cf8445ade209636476459ebbe3a0465454ad27a480aecbdb81f033c8358ba8"
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

    args = std_cmake_args + %w[
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
