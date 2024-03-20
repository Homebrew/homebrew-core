class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/refs/tags/v2024.03.18.00.tar.gz"
  sha256 "e1d8d7cc0a718e3c18934ac198ee3ad63848b90e8a19d62b2b7d54f0c878089c"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3bb05cc2f46998ca9e0d5ba7803d008d0ed06752d72c7cb7ad82328b88847fee"
    sha256 cellar: :any,                 arm64_ventura:  "4c7caa7c9010e886c62f8ef070f8510cb1d70192e2dcabdfd5a924b7c1cd6d64"
    sha256 cellar: :any,                 arm64_monterey: "3244de2aa0f845b2ca3a624d1fc909f913e0a5843223d1e7b669069c6b57e9cd"
    sha256 cellar: :any,                 sonoma:         "8f93805bf228b4ec1f4e54b79e05ed8ab54b829cf5296c9b5053ae8a61c800ce"
    sha256 cellar: :any,                 ventura:        "338bde75404ec6d851063c0f272d1fa6743691e0be4acf0fff73d7fde7917cd5"
    sha256 cellar: :any,                 monterey:       "69117f656994b0047ff907917889804e353b3225a5ec9b89c9d1460f5acb56b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e2ebfded24a27aeeb2ac7a64244fb65de2b1e531c2b3de6a84b1ac684cb9fda"
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
