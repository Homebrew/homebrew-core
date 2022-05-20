class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2022.05.16.00.tar.gz"
  sha256 "dfc15d27f25d33e25f23b42a391d45f1c890727a271a4d078e035e374d3c5666"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3d13d35d9f21ad6c45b6daafbc9b99f5bae2a926a44c0812e0336046dfebe326"
    sha256 cellar: :any,                 arm64_big_sur:  "133e86c93c7f16c765bec1b861430fb4cadecd9dc7b9ab80c986e0a75a661109"
    sha256 cellar: :any,                 monterey:       "15e121aabd9122655a657ddc50422f1bd8928b010548036b034af7fd41191f4a"
    sha256 cellar: :any,                 big_sur:        "b2ddfeac6454a31ed7bca8a957b290744561744b5de6d070b56d3db242fab2da"
    sha256 cellar: :any,                 catalina:       "a9bf0402f156aa885381ff8e7bc0281093719f291612d089ceac47834cbc243b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54b214d7504bd902ea989911642e5068cbdcfd16f430a30f914a2a95020401a5"
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
    depends_on "gcc@10"
  end

  fails_with :clang do
    build 1100
    cause <<~EOS
      error: 'asm goto' constructs are not supported yet
    EOS
  end

  fails_with gcc: "5" # C++ 17
  fails_with gcc: "11" # https://github.com/facebook/folly#ubuntu-lts-centos-stream-fedora

  # Fix build failure on Catalina.
  # https://github.com/facebook/fbthrift/pull/500
  patch do
    url "https://github.com/facebook/fbthrift/commit/eb566ef3fd748c04ecd6058351644edee0d02dbf.patch?full_index=1"
    sha256 "12286a10e3802e15ea03ea4853edd8640f9e5aedcac662b324a708625348a809"
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
