class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.8/llvm-project-22.1.8.src.tar.xz"
  sha256 "922f1817a0df7b1489272d18134ee0087a8b068828f87ac63b9861b1a9965888"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e20d0dbbf9f69f0867b35266ec5c64e2483d2ec9a5275cfe1ae2781cfeb5ad75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f943e52e18ec8cfda8ab3174eb733017600af529203e53a3a49443044656f46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33059fc48804586223ece39cdafba74d6ec600ac792e3bd65c031f760278435b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8dd7c9efe79e3f69b901ea1e7e3fbd0aaa4ee887e76e13bf38ab8f22058ab49"
    sha256 cellar: :any,                 arm64_linux:   "8f77d7106b7b5af26a131022ec91b1b926d6fad7fb7abb4aa322e7e3a8300b38"
    sha256 cellar: :any,                 x86_64_linux:  "442dd96bb8ecbc6a01c8c7245ecba01567511b0626dba79a349854a68897fc2f"
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
