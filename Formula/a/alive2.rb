class Alive2 < Formula
  desc "Automatic verification of LLVM optimizations"
  homepage "https://github.com/AliveToolkit/alive2"
  license "MIT"
  revision 9
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
    sha256 cellar: :any, arm64_golden_gate: "9a61dfaf01f72c515cbd4b1127cf512ec33bbd147ed7f781da2fc00b2da15b12"
    sha256 cellar: :any, arm64_tahoe:       "ada768e1465e47fbba98c9261b2d697a50cd384fc9d4e34e67d417dd84e7263f"
    sha256 cellar: :any, arm64_sequoia:     "b2bcc15f25f024c240fc0a2803a76554adffd2338fe32a954936f550766e0900"
    sha256 cellar: :any, arm64_linux:       "6e4d8da2108ed770615e5143e495fcc21bbf36cf18307c2f1fabe50a0358a23f"
    sha256 cellar: :any, x86_64_linux:      "3b484db0bfb6537a57c9cd065849243e71afda39b2612f61245e3556fc47ded0"
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
