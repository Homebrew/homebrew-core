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
    sha256 cellar: :any,                 arm64_sequoia: "91de2844001d0f3c72e4dd3d3f9308ff3c52ee4e66e4b70d679bce6cdefb0a68"
    sha256 cellar: :any,                 arm64_sonoma:  "db9a8607f2f9594345bc25c45792d5bf7fe5dc8310213e19187c85c133e37d34"
    sha256 cellar: :any,                 arm64_ventura: "a7d5c7fb250c3835929c4254f6552dbad12d8f245c5437a0a4cbcd7cb585f9c3"
    sha256 cellar: :any,                 sonoma:        "fdd8b62c429b759b4e6883cbca97730d499acf3535216a0236503f9c8ccde13f"
    sha256 cellar: :any,                 ventura:       "08d5619a9ac5d9b6449997c9dbc51186b784f77bba97eb01d20af8ba6563842f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb4a0454225b275bf9d4db01669b6c3fb5a9792efeb4a559119d7f3db204b77d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5ec7c86d5e6265387ca2b2bf2689cc1cb136a6881cbae822968e655dc83aa40"
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
