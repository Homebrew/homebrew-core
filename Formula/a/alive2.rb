class Alive2 < Formula
  desc "Automatic verification of LLVM optimizations"
  homepage "https://github.com/AliveToolkit/alive2"
  url "https://github.com/AliveToolkit/alive2.git",
      tag:      "v21.0",
      revision: "913e1556032ee70a9ebf147b5a0c7e10086b7490"
  license "MIT"
  revision 1
  head "https://github.com/AliveToolkit/alive2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5675de65ebc52814b9c54323af8dee2c8f6601c917c6652ace10dedc6cbc2b10"
    sha256 cellar: :any,                 arm64_sequoia: "2b50bddff87ab541451702d2c7d004412b8b10ae2b946a2efba614943cbfef58"
    sha256 cellar: :any,                 arm64_sonoma:  "c36cbe7db0301802dbaed9106d464e15979f24d842d73ea3d092ee6a74740317"
    sha256 cellar: :any,                 arm64_ventura: "b414bdbfb3e39fade927d5241a03c78bc05346359d14d72d222819fa79b2b01d"
    sha256 cellar: :any,                 sonoma:        "44f20bc496219036254e1e751090e6d1cd5349ad97635ab1d3c26bffa184f0a0"
    sha256 cellar: :any,                 ventura:       "e7c67408e23dd90ca063cb508dea9060a5f380bbfcb3927481908784872560fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5c21492b9c865c0b252c360129e047c6d0260180d8d2fe9dc36dfa57aab6c55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9fe289bc8cd5bd27db7c60c76084b6b9b72ffe6a1fa5dae9f43ede9367fb4d9"
  end

  depends_on "cmake" => :build
  depends_on "re2c" => :build
  depends_on "hiredis"
  depends_on "llvm"
  depends_on "z3"
  depends_on "zstd"
  uses_from_macos "zlib"

  def install
    # Work around ir/state.cpp:730:40: error: reference to local binding
    # 'src_data' declared in enclosing function 'IR::State::copyUBFromBB'
    if OS.mac? && MacOS.version <= :ventura
      ENV.llvm_clang
      # Also link to LLVM libc++ due to `std::__hash_memory` availability in newer header
      # https://github.com/llvm/llvm-project/commit/17d05695388128353662fbb80bbb7a13d172b41d
      ENV.prepend "LDFLAGS", "-L#{Formula["llvm"].opt_lib}/c++ -L#{Formula["llvm"].opt_lib}/unwind -lunwind"
    end

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_LLVM_UTILS=ON", "-DBUILD_TV=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      int main(void) { return 0; }
    C

    clang = Formula["llvm"].opt_bin/"clang"
    system clang, "-O3", "test.c", "-S", "-emit-llvm",
                  "-fpass-plugin=#{lib/shared_library("tv")}",
                  "-Xclang", "-load",
                  "-Xclang", lib/shared_library("tv")
  end
end
