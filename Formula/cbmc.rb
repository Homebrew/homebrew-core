class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.68.0",
      revision: "52e004c30dfc8a07bb6154dac182911b573748d7"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0d905887eda4d20b0fa2a31ca4183d65d5dbf970473ea4f2ff7a4e780779e39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b6760f4f738d6f0d0be4de35bb3df29442ce9d740e1fef187cf0959bce3d756"
    sha256 cellar: :any_skip_relocation, monterey:       "e491478ece9622993f5bf06c9f1dce87dbd67bf70a10b07b3d00127ddef5d387"
    sha256 cellar: :any_skip_relocation, big_sur:        "c341082e8b4d96dcf00f9cbfeddb721eb76e63c321a1380066024bdd56be52cc"
    sha256 cellar: :any_skip_relocation, catalina:       "38305e5752aabe8eb8b10eedade10358b06a2e57b23f62474df1ead3cfaf9f5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b0d7471bc77bf46b772883f31988aab6664d1fce7e49fc9d466b2f6e0c95a4c"
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
