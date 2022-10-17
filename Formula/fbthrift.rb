class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2022.10.17.00.tar.gz"
  sha256 "46d78b3f8be23604c83f3ef714b3d3898e7b845bdc82a12d48b5955e64abab25"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "16f9abc82a926bf591a757916863b20cdffa5036b7e74d7f1b15b79d03c98869"
    sha256 cellar: :any,                 arm64_big_sur:  "23773b257fe018a20641ac2a9c499796f0df1a13f7157d7698a5def13bfc3125"
    sha256 cellar: :any,                 monterey:       "9b772e33b793c38cbb86141fc38a9a110190f54880614ebcd6460f070634a533"
    sha256 cellar: :any,                 big_sur:        "51d20ecd7c3a068f9ba97932aeed291ab0bfc957527442fac7217bef2f5fa8ee"
    sha256 cellar: :any,                 catalina:       "ba988c3c85d7f9ed16ead09cb9a7373ce150755566f862c9ee7f77116647b6a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee0ca9814e65fd79429bc7a08feee78fbd2e2a3ec3749d11af3d4a8d7a9656bf"
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
