class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2023.01.09.00.tar.gz"
  sha256 "61664fbf5e886186c097f10b8dae12b643d392ed89c56f099ea38f8083c807b5"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f246465fba091e65aa18ce433ed57529b597d551fb2909d00cde5af3d8b031b5"
    sha256 cellar: :any,                 arm64_monterey: "337d1e6e508ad26d4d505a97114e81a6eab57a51b74a2f87d0d687ccdc5d8112"
    sha256 cellar: :any,                 arm64_big_sur:  "7328d01ff3c378525d77358826d51240753550e811c46bae4ef0497179f60460"
    sha256 cellar: :any,                 ventura:        "8c405dfbda899a77e6bf3c5f71b35c899262d98a6fa60a9c8be6b2c80eec72af"
    sha256 cellar: :any,                 monterey:       "607218deb566961436a36e2f0804368f85d7885118c86301f5065f7b6df6e408"
    sha256 cellar: :any,                 big_sur:        "eea923df3d75ce58e274b3f274e642ea5e453d0a8459e152506ffd7cf2a936f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "891ba49cb2236849cf0f81c01cb23c9eed1b575ac4f4515e01e5da05141aed7f"
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
