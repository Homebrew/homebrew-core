class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/refs/tags/v2023.04.17.00.tar.gz"
  sha256 "e0c67b2ce934c520c1cbc94055ca028fb872ee7595f909054f9f05d9ae5f883f"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c8e77c7cf10c93850ef932e0b913eb510d1acc06c830b4d82771b445f01c24b5"
    sha256 cellar: :any,                 arm64_monterey: "5326687cb21612ad98993be0fc364cdb699606e6b9a99eb7f4254163e4b6db57"
    sha256 cellar: :any,                 arm64_big_sur:  "703d3be31c2015e2c1679376adbc013989d1f904bdef69b7db2b0bcdce06187f"
    sha256 cellar: :any,                 ventura:        "5df71a89baebae3d33e4cb3a1db8a88327eb3528b4e61c64702cceb6a3cbd9d4"
    sha256 cellar: :any,                 monterey:       "2fa003f820109bd0e00648bc5c6658f5ffd9efda31af8aeaed14c6f0f3f7ba16"
    sha256 cellar: :any,                 big_sur:        "8bd0033dfb75255061a2b9dd002807398480ed5910ad969f893f242c14b9ddd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2452731def82bb2feb1d2d2c6b6b054c3fdfe3ba5583c6f949f753b4378ea1c6"
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
