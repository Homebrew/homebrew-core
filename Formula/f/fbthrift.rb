class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/refs/tags/v2023.10.09.00.tar.gz"
  sha256 "d402676e08df73e2e4b45ed99bef8b0c05f08ef41f606c8c2c19efea552948e6"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6505fbcf294b721ab7e1de4f9abca25b04180c10b633e4eed214730c50aedb01"
    sha256 cellar: :any,                 arm64_ventura:  "46c4febc7cc45c387733a71b4590d018f2a63e21497d7e95a61b42e1c33d0b83"
    sha256 cellar: :any,                 arm64_monterey: "1141aea47a2085f0b55b0ef5dacbabc5c62321cb5626a23ac992b67908d2d18a"
    sha256 cellar: :any,                 sonoma:         "7ee4b3477388ba93de46ae55c2eaa3615ffd6fe195502f7499f6263f7c467345"
    sha256 cellar: :any,                 ventura:        "c76b153c188f134f752219f6a07e65f492a39b0fd24b6b75b2c1ff25206fb9b0"
    sha256 cellar: :any,                 monterey:       "5c505b2aa06d9c4aafd8a413d525861d0f9086335d724ba6dac663bfea1b15af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fcaeee37c6c45e65716a882ad07d805e6a518773fd619f78de68acc0c27f9c1"
  end

  depends_on "bison" => :build # Needs Bison 3.1+
  depends_on "cmake" => :build
  depends_on "mvfst" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"
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
    ENV["OPENSSL_ROOT_DIR"] = Formula["openssl@3"].opt_prefix

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
