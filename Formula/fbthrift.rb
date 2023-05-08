class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/refs/tags/v2023.05.08.00.tar.gz"
  sha256 "264761857ce444a073776e99946ecb83c431020e5b864904e91d2597f636ddd0"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6ef6077a2282c441fd421a98d66d6ded9a0b6a2353d433da3fadad19949ea484"
    sha256 cellar: :any,                 arm64_monterey: "6129176154ec2cb56a54f16982d68ac23a540ca9061bec3978c28fbfd04a4702"
    sha256 cellar: :any,                 arm64_big_sur:  "de3c8f1f212b655039dd30b7591ecbdf93622ce77609b06af71dc161f608de36"
    sha256 cellar: :any,                 ventura:        "f9152f0705a7f6c3fc048cf63c40efb3edaa656bb2ce6a110abba9be6bd9dcf8"
    sha256 cellar: :any,                 monterey:       "8c0b6349d13f3d504a4e480e73cf4f23e2bf04afb5fe8217a7efc1266b37c444"
    sha256 cellar: :any,                 big_sur:        "f9fb86e402156d849d4cd0c2bff0245df0a2919be251d768dae4cf10e6b368fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "294c081faa6709870d145635d7477038630075b0954f8d2c61dc8eb9eb8eb2f2"
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
