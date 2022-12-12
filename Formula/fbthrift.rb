class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2022.12.12.00.tar.gz"
  sha256 "a46341b2c347fa5e64dff330e210e093a56b487aa20cc38c9e8ccdbaa5e15c83"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "75741560c49cd130cccc369d6c3b8bce1e305606217383736b75f6f519b19b26"
    sha256 cellar: :any,                 arm64_monterey: "77723ed238ad1fe94e565f612f27da5720e63415ff8937f75791c5e4b16dab41"
    sha256 cellar: :any,                 arm64_big_sur:  "9cf300d542b3d8608357435b7883b885f8b88f8833620a2be453d5f321cf2f77"
    sha256 cellar: :any,                 ventura:        "dc1f7a685c16c3bb67307364bd61a6c5c60b8d8e83dd9389f6a130b920e83a86"
    sha256 cellar: :any,                 monterey:       "bae2a6ac93054554d06aea0a4c35e272d1dc209d797debc02d8fe5d845a87ab2"
    sha256 cellar: :any,                 big_sur:        "7cfb6a5c6ace6c66f9fc43ece873ae9039f53b2ee4df7f075fed0c30194bcb63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc65ffea0c0bf738bddc7f8bbefcfc13c38afe03de3ab34ff6fa158b2a4b5c1c"
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
