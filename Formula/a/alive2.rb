class Alive2 < Formula
  desc "Automatic verification of LLVM optimizations"
  homepage "https://github.com/AliveToolkit/alive2"
  url "https://github.com/AliveToolkit/alive2.git",
      tag:      "v20.0",
      revision: "c0f5434f402ad91714ee0952f686cd0f524920ad"
  license "MIT"
  head "https://github.com/AliveToolkit/alive2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b3c6d86e1de46c4d5e154458184fac5402a56c42ddb94536f889b068fcfecba2"
    sha256 cellar: :any,                 arm64_sonoma:  "d1313cda006605d23b8f50cc20715989e438a5a181046c3393446aae027574a8"
    sha256 cellar: :any,                 arm64_ventura: "3633942d2a7e78b265bb2c3c7d648e8072fd5086c3e917b8d9fe528ff7412b3b"
    sha256 cellar: :any,                 sonoma:        "ffddb70cf02bf98df46e889b906833d0e6bd11ca768ecf4a19e22ce993e07abe"
    sha256 cellar: :any,                 ventura:       "a61028a3361668a76d287cf20e3b48cda0be2a27e701f79a88a12457f370996f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f1fbd311f2bfda369fc23d87228666fa1017ee7b61ba4a864e180b57281cc44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d10e5f546196557d33c2a10d3b119a1357268c3447feaca49445f95787da1827"
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
    ENV.llvm_clang if OS.mac? && MacOS.version <= :ventura

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
