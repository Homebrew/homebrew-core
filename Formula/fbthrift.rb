class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2022.06.27.00.tar.gz"
  sha256 "8d3a9b720f6ad836e218a1c247e33071a2d8fafc9fc041323b9ca0b4b02d788a"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4bc0ac85e0987da1cf7a08065bdd5d4212d9ba7fcaded0da8c777655cd115861"
    sha256 cellar: :any,                 arm64_big_sur:  "b3e72d264040fff091159f26e00a39f27baf1eb44ecffd49669b41078d8995e0"
    sha256 cellar: :any,                 monterey:       "60093ff2e17d1d8a33137a0b59679b9b4273798505c46dc82c1097a5596bc6b6"
    sha256 cellar: :any,                 big_sur:        "387013139788ea80c118690c1fbb37a842ecd0409c8e1b998d2571bced4465ff"
    sha256 cellar: :any,                 catalina:       "01af9dc470e0fd2c77e1e82531de4b51d68894bc29e16e0193acb30dc76ca8a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2f38c80c4e6260e4b974d8e8db0b20dd1ae61eb1414de61f5fecb1ed962b0cd"
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
    depends_on "gcc"
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
