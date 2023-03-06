class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2023.03.06.00.tar.gz"
  sha256 "185019e8205eb3d143b084fcd0a6c65474de30c1ce5da1a6e145cc11f7655ffc"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cf75d701053c5cf95057b87ed1180242bae92419f616e4d661419b88a7b84898"
    sha256 cellar: :any,                 arm64_monterey: "91fb4e2c487a0bc914d246db5f9a0c832c1aa3dec1dd174cfb742ad8764ca9c2"
    sha256 cellar: :any,                 arm64_big_sur:  "46476703e801daa582f315c139f49d3d7a5ad241bceeb81a6b3c4b80a8cb93d8"
    sha256 cellar: :any,                 ventura:        "ee053ad4f5c2193ea257a20e7107969c9a2f7f7a1c2b45283de5cc503e7c3c06"
    sha256 cellar: :any,                 monterey:       "47b6368ebe145ad566bf0253aa43355c69e9778645deaacb7b21bc21adfc8ea5"
    sha256 cellar: :any,                 big_sur:        "310f335cb8facfa00d83ff68fed7a7f5168b8289503cf3a1f13fd5dd6ef8a714"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "668ceb534f2a30047b1f74d344c84e76dde9eb88db810247ea303d9a9f157830"
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
