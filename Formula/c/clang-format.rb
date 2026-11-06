class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-23.1.5/llvm-project-23.1.5.src.tar.xz"
  sha256 "fb50b1eac93ddeb3aa8dab4cfe324dff74f4a9c2bdee6160c9e36188f8d06a6e"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3104900788d1036a356fd7ba0ccdb4f8e8b8dfb8aeae41fff22ccb0cf5b9f16c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "99432751d7eaab69ef3aae8bc604e87519d7705f5174f57b6de181e6ac2ad00a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "00ec74feacaa5102ebb1efb435682ac1d24d22c981731f28d48d6d4ff2fee984"
    sha256 cellar: :any,                 arm64_linux:       "ef45784caf622ee0faa9747063fffc7d0c3c576b787bfb068ec99ce40fc158a4"
    sha256 cellar: :any,                 x86_64_linux:      "99753e24fd05e249cd8c1642c16b5beee8f9adcf8bc91551639d7ff5bf7fd4ec"
  end

  depends_on "cmake" => :build

  uses_from_macos "python"

  on_linux do
    keg_only "it conflicts with llvm"
  end

  deny_network_access!

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
