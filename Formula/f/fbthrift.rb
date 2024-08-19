class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/refs/tags/v2024.08.12.00.tar.gz"
  sha256 "d6ff9d28ad25f3769ff7a02ead4a5d2f74d47f138165fcb51624a6c3585a831a"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3483e27d113e44095bdbe615ab0a66f5113e92a8d34e8d3576cc23bbf0937b92"
    sha256 cellar: :any,                 arm64_ventura:  "df0a29e6de37d5a53d446beb1b88b7f4d661d13ff9daf7bbd2a65bae20947785"
    sha256 cellar: :any,                 arm64_monterey: "51759a7828a12ed75c47a4fc17348b7f622cf06fab30456a4b39b60bf4fdaa5f"
    sha256 cellar: :any,                 sonoma:         "318b1fe8ab787840a1f0c02cf504b50b26d01308c54e278d70b0872ce9bffe59"
    sha256 cellar: :any,                 ventura:        "6463bf1fe5a844848533f1c9bcb0dc98610bdc5abaefc7f236720822384a6b9f"
    sha256 cellar: :any,                 monterey:       "6fb30547f4f0d3e37a4a85d7939fe171327bd92b4e79b5c054e6861a9e8c134b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8747dce51eed7e7a8005d9c381805ee0a2493fe11113814a457ce6d0cb6bab8a"
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
