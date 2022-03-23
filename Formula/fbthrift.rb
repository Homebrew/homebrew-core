class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2022.03.21.00.tar.gz"
  sha256 "7310d177b3ba2827912b7307b30da6e6da0d6afbe419b261a0fc4e63a26c1c54"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b4f4cc6897ff57a72bb0986bc0f888c0e4b4f5e3336d56add52f46c594040fdc"
    sha256 cellar: :any,                 arm64_big_sur:  "123a529f1f1b43fb03c730eb0bd35df6d70ec39237a2b2907ba5e207fca87767"
    sha256 cellar: :any,                 monterey:       "ad5dc1dfdda46732acbe17357039d17850da657fb3dc654a1cd7f2ff01e3dbed"
    sha256 cellar: :any,                 big_sur:        "3827baa7a4ca3c69bfc3c39a76e8807df198eaaf15097e654284674b0f01fd70"
    sha256 cellar: :any,                 catalina:       "40ea82bd37d7b4ef068e8c524067bab922aaa4529c5e7cf122c52d05115a98b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "faa70c144caf3b8075032e87e7e8d7f2277e0f1d78b5a87976a4c122269e68b4"
  end

  depends_on "bison" => :build # Needs Bison 3.1+
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@1.1"
  depends_on "wangle"
  depends_on "zstd"

  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  on_linux do
    depends_on "gcc@10"
  end

  fails_with :clang do
    build 1100
    cause <<~EOS
      error: 'asm goto' constructs are not supported yet
    EOS
  end

  fails_with gcc: "5" # C++ 17
  fails_with gcc: "11" # https://github.com/facebook/folly#ubuntu-lts-centos-stream-fedora

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    # The static libraries are a bit annoying to build. If modifying this formula
    # to include them, make sure `bin/thrift1` links with the dynamic libraries
    # instead of the static ones (e.g. `libcompiler_base`, `libcompiler_lib`, etc.)
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup" if OS.mac?

    system "cmake", "-S", ".", "-B", "build/shared", *std_cmake_args, *shared_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    elisp.install "thrift/contrib/thrift.el"
    (share/"vim/vimfiles/syntax").install "thrift/contrib/thrift.vim"
  end

  test do
    (testpath/"example.thrift").write <<~EOS
      namespace cpp tamvm

      service ExampleService {
        i32 get_number(1:i32 number);
      }
    EOS

    system bin/"thrift1", "--gen", "mstch_cpp2", "example.thrift"
    assert_predicate testpath/"gen-cpp2", :exist?
    assert_predicate testpath/"gen-cpp2", :directory?
  end
end
