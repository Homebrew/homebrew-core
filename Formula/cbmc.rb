class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.53.0",
      revision: "d0c594f3cf25f242cf5bd608798c9a3a24d5d304"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4099bdd85ef6be84f78b7f9707bf453723d59050cfe12736e07245d0f3cea3c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14e9255cfc18ab9b9a0b8bdb8bc2c49b92ddde9b096e1508e01f40716e83c4ec"
    sha256 cellar: :any_skip_relocation, monterey:       "35ed89ffb0cb397d5db4dcd4cf829ffd9aca4b2f8bea62a699a1a5915cf82ad6"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4a4e1d4acd2c78f1be17aac6cc93295726dccf338b6877952a5ce83e33d0eae"
    sha256 cellar: :any_skip_relocation, catalina:       "f391ef12bc3ecc961099d9b02d724d52072b77191a901d97bbd9718834dbe4a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9175cfdd8f0f26918a3ed73b3bf64e62546ff1dd3e8bf6b1bcff20e464a7a289"
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "gcc"
  end

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
