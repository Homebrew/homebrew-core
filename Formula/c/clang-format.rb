class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.4/llvm-project-22.1.4.src.tar.xz"
  sha256 "3e68c90dda630c27d41d201e37b8bbf5222e39b273dec5ca880709c69e0a07d4"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eea8742bb2437833d73a4afde329d6b811ebd3d2e0a890472f2081fc86f0c8f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd70ac5ed341234ad43c0878062649954f41813e6962536559d55a9c5638582c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21b25b0140a720c41b9beffa35383308b49fb63e40c5f3c51901133b5ee0deb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf4ab01e77e0eadfaee0b35de54e67a6daeca7a7147eaee85a2b1f3bed3ee9b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4596943bc554a1f8b3da8dee37b559283cde44c074ba709581b8150a075e8b31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2eb4bda7c93969f755ca09b22c2f8860edb4d4d6d6c82e0996959109bb1b49e"
  end

  depends_on "cmake" => :build

  uses_from_macos "python"

  on_linux do
    keg_only "it conflicts with llvm"
  end

  def install
    system "cmake", "-S", "llvm", "-B", "build",
                    "-DLLVM_ENABLE_PROJECTS=clang",
                    "-DLLVM_INCLUDE_BENCHMARKS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build", "--target", "clang-format"
    system "cmake", "--install", "build", "--component", "clang-format"
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "initial commit", "--quiet"

    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~C
      int         main(char *args) { \n   \t printf("hello"); }
    C
    system "git", "add", "test.c"

    assert_equal <<~C, shell_output("#{bin}/clang-format -style=Google test.c")
      int main(char* args) { printf("hello"); }
    C

    ENV.prepend_path "PATH", bin
    assert_match "test.c", shell_output("git clang-format", 1)
  end
end
