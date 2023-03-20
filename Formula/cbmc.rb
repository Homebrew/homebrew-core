class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.79.0",
      revision: "4af9c8a54867ca76e8c22d218d4eca2eedbf8d5f"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7199e591032cc86ba94cc55553996cf751e8b7122386340182c00298d035fa8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2b61c89dbb1e0b86df59a8ecdd8f19674ddd40ff5f88761a88edb347713ecc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de643eebaca41c33c334841a27a70818dfb9e2b6e99a6ae7e9c4b3f2327aa91f"
    sha256 cellar: :any_skip_relocation, ventura:        "ec8f46e0233d80c7b4fe48df5d868180122399ac20a49c4ee66cd02d30c12547"
    sha256 cellar: :any_skip_relocation, monterey:       "5704ac661a0b903db3d6c692145e3d4f3b2ae679b4faaa5401a446f945f5fbcb"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6dc62a263373777d43ac16137cbcca05742fac8743a4c380b04b528c1045465"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bfefa8da1662963bdb68b539f4de0f0f07d5675d632debc106d8481d86c0e93"
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk" => :build
  depends_on "rust" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-Dsat_impl=minisat2;cadical", *std_cmake_args
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
