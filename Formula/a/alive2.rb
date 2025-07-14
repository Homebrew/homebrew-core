class Alive2 < Formula
  desc "Automatic verification of LLVM optimizations"
  homepage "https://github.com/AliveToolkit/alive2"
  url "https://github.com/AliveToolkit/alive2.git",
      tag:      "v20.0",
      revision: "c0f5434f402ad91714ee0952f686cd0f524920ad"
  license "MIT"
  revision 2
  head "https://github.com/AliveToolkit/alive2.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c2e52c9df83cf4759cdc53761aec5cf533bdc24fc9812241c18f494a9e7bc836"
    sha256 cellar: :any,                 arm64_sonoma:  "d12f24a623fe6a7ae194b546ed2076cb9b71b7f2b2ffc8abacf6f004db446720"
    sha256 cellar: :any,                 arm64_ventura: "7226a45ac96be7b39e0e46ae592be043787bf4965438046c42f8268e54abac6a"
    sha256 cellar: :any,                 sonoma:        "08df28b20a2c4561764372987bb7c3a6bed76ec8dc0fa73545ada659ed6c940e"
    sha256 cellar: :any,                 ventura:       "5191a7a9eead8da3646a9f14a0fee799a34169c08f81305654f2548866a4e274"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3114b328118b8ad425d287974aba4102603651a8bbfd3fa230e053e999e9bf18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "705c815f0a0f02d812d19373f57777172297964a2a265bbd1631d4c82fb9309f"
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
