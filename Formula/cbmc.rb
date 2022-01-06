class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.48.0",
      revision: "b79bd515ca20259287602abd68d5a32c276dbdd9"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d9e9d738ed52464a3ba0f349eeae69dd7b89dc3bb643479056fbab92fb49cc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb70f4f8136dc64b4d13104c12ef4984ae0b0cf810fa5a72e333227591dc476f"
    sha256 cellar: :any_skip_relocation, monterey:       "c76ab4d035c2bb13d325779a634ad89ee9e9ccbce3d54fa0d5f5353d0e6b8ada"
    sha256 cellar: :any_skip_relocation, big_sur:        "829e1f86ecdc0868b5058c0d8953344f1a526bfe6d34d6d61ee220b93037c817"
    sha256 cellar: :any_skip_relocation, catalina:       "26b38eae529281b31dcc8b116c073da577b13e3be24693179b30c6efa72682ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dae2712bedf7d70ee2bce859ed3cc9477dedbdb112f42fe63ee3781561e1bb06"
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
