class Alive2 < Formula
  desc "Automatic verification of LLVM optimizations"
  homepage "https://github.com/AliveToolkit/alive2"
  license "MIT"
  revision 6
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
    sha256 cellar: :any, arm64_tahoe:   "b9e8841f08496058eff115a0ebf798cdc8c77c37702cea28f6106a9e3ab6d638"
    sha256 cellar: :any, arm64_sequoia: "619e135e6047099e77321e96e6f5d0a6d6edc7bbb84080425574d883124256d0"
    sha256 cellar: :any, arm64_sonoma:  "a98cbbdeac8cb881206cd2716beccf6f9da5ef7158316db647ce57718750effa"
    sha256 cellar: :any, sonoma:        "5efb790e848c145a255d1af531d11b06ca55d67aee8487a131eeaa69388baba4"
    sha256 cellar: :any, arm64_linux:   "499ba5b84275e135acaa4fef1789b88d079da085791c3f25bec4f4eb8046dda9"
    sha256 cellar: :any, x86_64_linux:  "7bff7aba2f8248a9ae4bbd2a8ca1d74b96095eac10ef4d972904b0c56c84a508"
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
