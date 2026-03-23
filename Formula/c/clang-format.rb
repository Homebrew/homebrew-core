class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.1/llvm-project-22.1.1.src.tar.xz"
  sha256 "9c6f37f6f5f68d38f435d25f770fc48c62d92b2412205767a16dac2c942f0c95"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5aa6f02594972b984bcf0bef481263cb6c06e90057fab484d1e281a74d02a3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a02d3c2e0afe1cdca9990116f5485515ba32fac77e9a3876674ec1aac978de56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50a8da7f3a0beac963dcb61b600075e78c046dcf8a88bcab98eb78ea241e798f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba4b859c2a82d2c346665392a3f10c626a9bf50d54344d88913c33fc2c030191"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5817ca23d3cf8e5377ee4335a5943a224003919f9091201ab4b8c2aa306a780a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47075d20bf0278ca1d16b66398db96f27f8868396e9412d5cbf4f847c5e52d8b"
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
