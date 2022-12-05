class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2022.12.05.00.tar.gz"
  sha256 "cd646e54d3dc96271bbfa08366db7d58a2cd913ceb767f3dd7af3cc75bba59c1"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1c6c888a5f51934b1413812a263c0ef229f13e7efabad3370b02e970987ba8e1"
    sha256 cellar: :any,                 arm64_monterey: "05a0efa2432772b3a782253536511b34834bd5d20a64161cdea8132554b6e479"
    sha256 cellar: :any,                 arm64_big_sur:  "9cfa97f03ebd4551477ade5c9b750d6d7c9d7f7fd5d171f52be8336f89e2cfc0"
    sha256 cellar: :any,                 ventura:        "2afc20fb4036acb0555e91ca659e164d6350bf5ba043a816415d957e97efe7c3"
    sha256 cellar: :any,                 monterey:       "ab33c8e9750de470f4c7039d0f23de3497c47831fd0444c140248ae3561609d6"
    sha256 cellar: :any,                 big_sur:        "9ae006c82d4d58f40d5eb8d832ff7d12ced1bb0523de1c37c0921e1854569c96"
    sha256 cellar: :any,                 catalina:       "41117f78015090e4add9e6666367d2de7cb4b6f30c3d49172f705edf8db610cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "834db9f061027d2c73deb06a1ae6fd17c99cf47a52ae59bb48e0f88b602d3d6b"
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
