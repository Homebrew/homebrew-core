class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-23.1.1/llvm-project-23.1.1.src.tar.xz"
  sha256 "ebe9be46fe8756d58c5b198ffad0fa2a766257add81a4dc52179bfacc7888ee6"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ea7650e37d69f4e436ee4510eab54845ab71f1027494df9424d8ed97f391ccd8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "86446d253944f92d485d82bd8a76188d2e701e362b6931939f3251c36be90794"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5e822f506e225c451b33573c3073df5b487b5ed1524c14adeca4f570a6125bc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "0a4ab72db6e96e3baae6ee81b78a1d0ecb77b5247cfb2631f75cac27cb1ec573"
    sha256 cellar: :any,                 arm64_linux:       "6b662582e446e2f715fdc021bf0354879f6d274650e54a3094a9bfcc616f872b"
    sha256 cellar: :any,                 x86_64_linux:      "0284aa162c4df3c5158431ee79b7d30d286fd95e52b728ea938fb1a8eee49d1c"
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
