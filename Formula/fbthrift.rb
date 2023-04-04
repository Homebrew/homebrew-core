class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2023.04.03.00.tar.gz"
  sha256 "16b6cc8731b47943eaaf28f44d9730bb4417f510432a5141538f8c035f85efd5"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "381f3ebf1b83bdfff433742dd73379e1a635353fad004987f8f615853c8c101a"
    sha256 cellar: :any,                 arm64_monterey: "a8ae803ca9d5c04304411ca801b07a38fc84c47ad14381f9dfd689bf5a15332f"
    sha256 cellar: :any,                 arm64_big_sur:  "cff72cd130e489e33a96c5bf3643b705561d56837f2af5a55a01036fdead9b7b"
    sha256 cellar: :any,                 ventura:        "a9de702afde999dec219a51b4db9a74e6d5fefa74d8a574a75ba8d14ed3292b6"
    sha256 cellar: :any,                 monterey:       "104d53e609a792ef3dea97d748700d905afaf4d8a9670e37e6c3de3d201d6d6e"
    sha256 cellar: :any,                 big_sur:        "66320b5f049bb383e91f3b970f87eb69cb71f2826b6000f50dcf84c6533ae146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "435de2d48b1a957ca700a7bca069eb68c6cf1d935c2ed244dab041d047cf9b21"
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
