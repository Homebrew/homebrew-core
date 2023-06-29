class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  stable do
    url "https://github.com/facebook/folly/archive/refs/tags/v2023.06.26.00.tar.gz"
    sha256 "e7b58bf4eda24e2069b301e27533deb7c171dac57925cb90fe344595522772f3"

    # Fix build with new fmt. Remove in next release.
    patch do
      url "https://github.com/facebook/folly/commit/e74fe5c99dd9d96b80b17f8396ce2568f2becb45.patch?full_index=1"
      sha256 "3f2ccd2c43ecdd1fa947d4d487b2fb73e260a68a2f3e85f0c4dc61f91f70a628"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5158abc0ee9afa045850fccf7b48d50515b41119dad1183060193310dad4417d"
    sha256 cellar: :any,                 arm64_monterey: "4920bda807554cbc304215c07039a377abb408fa6e002801c911d350d4d0814c"
    sha256 cellar: :any,                 arm64_big_sur:  "fd7be61b5577bfffcde05ceafa110cc1834ee9377394dc590eb1c1a746c1ff7f"
    sha256 cellar: :any,                 ventura:        "e0ed4400b93d91562f2238ff6f8578062a2e13fdc76ce197123aca80b57c0e69"
    sha256 cellar: :any,                 monterey:       "da618da566cf04b231c61573be5eff1bcd21cecd1cff4b5e45cb7918534fa5a2"
    sha256 cellar: :any,                 big_sur:        "f2cde28425db5593dffff3e4d9a4e1b3c654cc4fed0fa33eb97bd3441cb4a8a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebaaf1aeb9f12f1db5dec5ac82c5c230208b610decc4bb7f14062ad254426cae"
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
