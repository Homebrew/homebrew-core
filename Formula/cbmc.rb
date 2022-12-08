class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.72.0",
      revision: "9a84d62dabbf92e2a0e83bec136b9c6d73d6f2b1"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78a48921b949e9b445dbbb59b557c6ff135c9df0d6eb1b9ad50f2fd0d43e4b17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef623b843686b80fc8642e39df3b18e39c00b215ccb44f1b90b38f1639385585"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abf374ff4b390b578cab241360108f489beb9e20d8f76302139dffbbbb299b4f"
    sha256 cellar: :any_skip_relocation, ventura:        "3022a52172207872566e82f21b5d4d6d92bc7b590a6fe9baa142c6a682a6dfed"
    sha256 cellar: :any_skip_relocation, monterey:       "3cbbbb60620f13fe6cf94d2a9ce65bf79fcbbf1bc37aa334343bee73e70d1abc"
    sha256 cellar: :any_skip_relocation, big_sur:        "5460c1dd9293332780144060f00eee10464fb53df856aba000ed258c73aa54fc"
    sha256 cellar: :any_skip_relocation, catalina:       "283f1167c26341add17dd5421ece7a9c841dad787bbc0441e83b017dc22bb9f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fef44b052d5234ef96036c76c0b76a56da221972785e20cb3515c0b8ea50730"
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # lib contains only `jar` files
    libexec.install lib
  end

  test do
    # Find a pointer out of bounds error
    (testpath/"main.c").write <<~EOS
      #include <stdlib.h>
      int main() {
        char *ptr = malloc(10);
        char c = ptr[10];
      }
    EOS
    assert_match "VERIFICATION FAILED",
                 shell_output("#{bin}/cbmc --pointer-check main.c", 10)
  end
end
