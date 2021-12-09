class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.46.0",
      revision: "98afb5ef3034b6cf53822ca4c0484b5e9d222a50"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4292d034e944d9691a64a29ee7152178c31231da5d2d877a60dfe4fc3abdde3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5250281154228f8060d6ee705c64032d3b6d0a66a2266d94becc9c416cb10b9"
    sha256 cellar: :any_skip_relocation, monterey:       "d227fd2e1559905cd341ab4b335ade31f12bc2e604321506d156ab681e421ce7"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac7eea0d4566f03fae4519249bd0b36bf7189efa67eae9d483d4451b6a0ba514"
    sha256 cellar: :any_skip_relocation, catalina:       "40f8a89fee00251d6c172a8a295515acd5d1abd920321ad55d744f2d4b89370a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ee660b1de48c17a8e48ebc57b030f3080434c8a8601aaf672f5d6cc57cd854a"
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
