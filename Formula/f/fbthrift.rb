class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/refs/tags/v2023.09.18.00.tar.gz"
  sha256 "7e80528b158ab79b6136dd164ad2e5b3bd0c7d7a8e2e6d688c6b2271101c5801"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f1717b81075348b18ad87ce1d8a8d96e2ee334a385a8834b2dd3ddc40d234e9a"
    sha256 cellar: :any,                 arm64_ventura:  "b4c99ae2d1bb46f2e28714408a5c991b5abe66805617501aa205439fb8b0f13d"
    sha256 cellar: :any,                 arm64_monterey: "2c1ffb4ae667bb1216c369afc58b29d54e18e6d08f4eb6bef5b5c8e658e1d2b5"
    sha256 cellar: :any,                 arm64_big_sur:  "8950ef1392e09d7cfc2dc6eb9c6708836910924c5800209ce6087a71b3d9d45e"
    sha256 cellar: :any,                 sonoma:         "66c629e3842e2bbeea1817c2367520f0f10f1b63002139e5d709cfdd79e42807"
    sha256 cellar: :any,                 ventura:        "e80935a3a83ca238879a1ace4f453c1c704a9d0d3ecb132d2af0bc2f906b852d"
    sha256 cellar: :any,                 monterey:       "50e2ef3d7c1a087c6120eb7c2bb9f6a3d90c7b00612c04ce4a2b8d082d1be839"
    sha256 cellar: :any,                 big_sur:        "0537c91e055ef2af8784423c8a7f54a541d529bf9b65635993d5ea84d506521f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71d1e07829017a74f77bc850dea637e6f5ddf1a76b3c1cdd758e4aa6f4d00d6b"
  end

  depends_on "bison" => :build # Needs Bison 3.1+
  depends_on "cmake" => :build
  depends_on "mvfst" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"
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
    ENV["OPENSSL_ROOT_DIR"] = Formula["openssl@3"].opt_prefix

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
