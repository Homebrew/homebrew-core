class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.7/llvm-project-22.1.7.src.tar.xz"
  sha256 "5cc4a3f12bba50b6bdfb4b61bdc852117a0ff2517807c3902fc13267fb93562e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d8236ef83b92afca65312d9e10576e1708c8c587f0a518e260883d5f1c22d17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdb92ee24bca2a20cd9c45ae2931ad6e2a2d03318bbd61f38af7285693d1b76e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0446936f28fec0bcb44e29e18b4f6e823b708a40d1ff256af5d5c094d4770e07"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2686e32464690cfb553b37d556c15398855833d1d266d8d078ce6a231e45363"
    sha256 cellar: :any,                 arm64_linux:   "583624d645200049ee01de656693b7c4262ac7ad2aee193e143b9ddfdd89efee"
    sha256 cellar: :any,                 x86_64_linux:  "bfbf6445a36f1bf17818889799107f1246563889472e378a1ea943e5a1453875"
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
