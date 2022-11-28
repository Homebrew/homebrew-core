class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2022.11.28.00.tar.gz"
  sha256 "9a09a3f6f4d516fc1eeea231946f763c0092acb82fb54d5eab46cf346a12d7c3"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "97ae0628d83b6c1c9eb8be5a290158f24312fc0ea39b95d1606519608ae02371"
    sha256 cellar: :any,                 arm64_monterey: "6934c039d55609365e9f57d5cfafad445bcf6777d8c7feaafc1e7e510a0522e1"
    sha256 cellar: :any,                 arm64_big_sur:  "6550618944c11bcb4f8dcd21bd9fa6c11c7cbf1a5d64d181349ba69499992e71"
    sha256 cellar: :any,                 ventura:        "34b17abba02aeeb4e29bf9df4c6b7c3256ad5a185a1a5d46c7f14428c4ed488f"
    sha256 cellar: :any,                 monterey:       "17575abec4a1973ed24dc1c7a56db223888ffb362c2ff0c5d7e38f63a28b598d"
    sha256 cellar: :any,                 big_sur:        "a6940f7cf252620cda4f43e02aba3471c09edc7ac9949931082cedc55cf0de51"
    sha256 cellar: :any,                 catalina:       "b5d1ab9fbaab62bf1c4a61df2144b8e69e9e2f85f0fc32b253cd969b13b2e8ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3e92dfd5c2a51d9f288a3845f16c7443b9541fa4bd5fce957c11f88d663651d"
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

  fails_with :clang do
    build 1100
    cause <<~EOS
      error: 'asm goto' constructs are not supported yet
    EOS
  end

  fails_with gcc: "5" # C++ 17

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
