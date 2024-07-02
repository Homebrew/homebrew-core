class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/refs/tags/v2024.07.01.00.tar.gz"
  sha256 "fa2302fdabf54780213cc3c5b7047226d7d9b91b8e1b9528330f1041c16b25eb"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b7af06f7a0570680d000f2f368d8da2642511f5033d264e6b4fe3c29a253372a"
    sha256 cellar: :any,                 arm64_ventura:  "4afc5b3eab4ee6bf4ee5133a81b86e0075f33eba1621e7b05678e728ad01c13f"
    sha256 cellar: :any,                 arm64_monterey: "81adf50e5db896f27b15f55f79ab4b2337b37952607424a075b4ba0083b07fa6"
    sha256 cellar: :any,                 sonoma:         "6c5cf92f3f73c9907b7024fe1ac9f1241284d70268b9895d7d5c25dd8104db64"
    sha256 cellar: :any,                 ventura:        "c9ea841e897f6afd34d4ee932e09db4b7f6213d0c1f5f8d3bb27ce4321a9f5c7"
    sha256 cellar: :any,                 monterey:       "4e1621c073085e51e347c9f2a47b185b4ab714cd48d932ad92c3172c84ee1e9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8db663e523f1b021cbd6b01c8e3946454db8f3df94c1e286deb163fad4842ab0"
  end

  depends_on "bison" => :build # Needs Bison 3.1+
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "mvfst"
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

    system "cmake", "-S", ".", "-B", "build/shared", *shared_args, *std_cmake_args
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
