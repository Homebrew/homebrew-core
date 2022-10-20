class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2022.10.17.00.tar.gz"
  sha256 "46d78b3f8be23604c83f3ef714b3d3898e7b845bdc82a12d48b5955e64abab25"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4681de621638310f8173cd84a7a7730a71952789a77202ff64fe56de2f7a94db"
    sha256 cellar: :any,                 arm64_big_sur:  "3b6765b80df021ab6f1b5216f93125e00d259ae588992153bbf17f62ea2d0fb4"
    sha256 cellar: :any,                 monterey:       "b03b33f9fbf1a68880dd4469526051f7be427ae240a5b8e3accedc0a7b2f4466"
    sha256 cellar: :any,                 big_sur:        "d676237ec41890cdd453af511ed09400fba6ee04e846a852ec5166cf0f5c8431"
    sha256 cellar: :any,                 catalina:       "3e0232797bb56f60b345e4430d31cf8d4477bdc3e90cd0e33fa50ac5f9c2f052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb9d2732fe344e9a4dbee258d763c211b1bc9d894cc8232d93b224d2df6f44b3"
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
