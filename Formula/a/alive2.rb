class Alive2 < Formula
  desc "Automatic verification of LLVM optimizations"
  homepage "https://github.com/AliveToolkit/alive2"
  license "MIT"
  revision 7
  head "https://github.com/AliveToolkit/alive2.git", branch: "master"

  stable do
    url "https://github.com/AliveToolkit/alive2.git",
        tag:      "v21.0",
        revision: "913e1556032ee70a9ebf147b5a0c7e10086b7490"

    # Backport fix for LLVM 22
    patch do
      url "https://github.com/AliveToolkit/alive2/commit/a86aaa0ea44c5671ce3e998ec6d422feaa95b236.patch?full_index=1"
      sha256 "6645b59d29e7a4bbe45e91f57391cf9d4e5dbc27ba99a93c89ad13b14d57a7c4"
      type :backport
      resolves "https://github.com/AliveToolkit/alive2/pull/1265"
    end

    # Backport commit for LLVM 23
    patch do
      url "https://github.com/AliveToolkit/alive2/commit/155386f37536a8f64d78c0ef7d52f7d3f1926cd1.patch?full_index=1"
      sha256 "01b319ccbfdb2a8c2a98bd2d5fc2e5b9564511f2738afae1b8d125d014af1678"
      type :backport
      resolves "https://github.com/AliveToolkit/alive2/pull/1309"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d274056fef92cb8d35ba41e4ddb15e0e00b6b8d768e19dfc7d288bde53737e5a"
    sha256 cellar: :any, arm64_tahoe:       "931b34cb850a65f95e06ab2a89353246be54bdcaf6b2b4715a238f051b40206a"
    sha256 cellar: :any, arm64_sequoia:     "71925aa424b17ebae12b1814ff3e62ead260a10f7427f1d21d31eebf0f69dc89"
    sha256 cellar: :any, arm64_sonoma:      "4cb092264a0d24937d3cb5c27c9e83c0ba43b121a4ec903918de096e520b8c53"
    sha256 cellar: :any, sonoma:            "d4c1fc8506bd3e1784eb36e441e4dd38c1bca22bbd60b8abad15c30b403136b3"
    sha256 cellar: :any, arm64_linux:       "94a0b799c7260777405c892fcebfd7942462a3f1b33a6456d9497477c879895a"
    sha256 cellar: :any, x86_64_linux:      "499312176a17d4874b3bab005293337c587029c9dbe8cb77d75ed3da1d25d8dd"
  end

  depends_on "cmake" => :build
  depends_on "re2c" => :build
  depends_on "hiredis"
  depends_on "llvm"
  depends_on "z3"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :clang do
    build 1500
    cause "error: reference to local binding 'src_data' declared in enclosing function 'IR::State::copyUBFromBB'"
  end

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_LLVM_UTILS=ON", "-DBUILD_TV=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      int main(void) { return 0; }
    C

    clang = formula_opt_bin("llvm")/"clang"
    system clang, "-O3", "test.c", "-S", "-emit-llvm",
                  "-fpass-plugin=#{lib/shared_library("tv")}",
                  "-Xclang", "-load",
                  "-Xclang", lib/shared_library("tv")
  end
end
