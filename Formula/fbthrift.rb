class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2022.08.22.00.tar.gz"
  sha256 "7fde3a31eabf1da85124cde770cf5e5a5126d809b04205a41fd6fc9fc24392da"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7002067d84fb2ac62de34e3150b28b1df0206ba24df1e6aaf68efa37f7942856"
    sha256 cellar: :any,                 arm64_big_sur:  "ef892fe2a2d690e387035b5ec5817001d88716153caeed8dd7d4afa0761849b5"
    sha256 cellar: :any,                 monterey:       "ac17f72ffb683bb25c67eef3f6cdc13a5c22bbaee82323551d2755db89766c37"
    sha256 cellar: :any,                 big_sur:        "1247764e92a92ccb087c432a3458ee925310cf7f363655c163173ad716f7d215"
    sha256 cellar: :any,                 catalina:       "1dcdf86bab000818aa40691d7713c0245c7878ac1d57223066208cfec09acb4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04a202a2fead93efca7defe56576a7292d91d47d0c0b3df4d450aac41fccd664"
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

  # Fix missing `#include` on Catalina.
  # https://github.com/facebook/fbthrift/pull/513
  patch do
    url "https://github.com/facebook/fbthrift/commit/ef6dc2e6f5d6d1713dc1937ad7e65bf00b3467f6.patch?full_index=1"
    sha256 "3085cebc8ad65859277fd916e01a8dddcdd78ec69bbde526571bef6b72fac519"
  end

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
