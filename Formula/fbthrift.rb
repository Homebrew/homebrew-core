class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2022.09.26.00.tar.gz"
  sha256 "f64ff5835986cec70c7c860b3dec5b80f195f0d318893da93136276e77f3ef15"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8734cbbe4154eb5b6c9fa0c2b83001f5513c4607b19c51e8c19afa5d80c6f1c5"
    sha256 cellar: :any,                 arm64_big_sur:  "9c5cb41d3d4f2d4ea78cc6fe613fdb97a956315057b8052631ba074605ced92c"
    sha256 cellar: :any,                 monterey:       "1787ac79f0878f908c3e64e2483adc068e4f7bcd3d78808fe4d614eee07c27fa"
    sha256 cellar: :any,                 big_sur:        "c330dbba6160965f436447dfe3f1e3d6cf51842e53f927231d2e421956ee9495"
    sha256 cellar: :any,                 catalina:       "343658709ae774cff05ec94b872b3432cca442565bf1843706dc7de8528ef4df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1343d5524b575e39a749814b04ad7250fa946b83e8f55c3f401aa1e73b5b070c"
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
