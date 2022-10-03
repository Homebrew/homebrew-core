class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2022.10.03.00.tar.gz"
  sha256 "e89de2d53aff2a2b1a9f1b8aa6f1b803aa3e25f676b1dd87856b3188ea4753b4"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9a8fccb628aaf251a2654bf8e67cd4713a8bed69aef5ad6c7f469e2a8920a42f"
    sha256 cellar: :any,                 arm64_big_sur:  "035f24a7f991edbcb77b0025a703b2ad7339d373acaed89b2004e00c375ff2d6"
    sha256 cellar: :any,                 monterey:       "89b6e55a1aee10f0a0436aa5b03a6588d02c060189899d93a8084fb847511145"
    sha256 cellar: :any,                 big_sur:        "c18c3e1bdc590378e206a70dfe3da039e27adb5e7baf87328b53408d99f7c226"
    sha256 cellar: :any,                 catalina:       "91241eb80390e875899b51022b08d10e203c524fc05c05caa7aa6effafcb0137"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9941400ae5ce1cde0a9effcf0bc18fdf2974ec3aba397a831c2c5b6f72b8c131"
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
