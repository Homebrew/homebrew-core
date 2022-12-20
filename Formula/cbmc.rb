class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.73.0",
      revision: "3d8c1f891e09a969071dc87d01991b95a9b4a037"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a527ebe4f01b837ee3e4f84de5f1c25e6d156b59991a49d0838f17aca209c94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3540ab89df865517fc9c080a22e0b62d9d2789e69770bbde77dad71314d57878"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c90f66033ce8cd94f559108cbd62273c9d0661b9f51a89bfb60356ae87c03834"
    sha256 cellar: :any_skip_relocation, ventura:        "5a5de26461d8ad97b14e349a921b6062d2188cfc61d7289583ec9782c1ea30b8"
    sha256 cellar: :any_skip_relocation, monterey:       "b2e5f3c22feb042bcdfa228302b79a0061434764a54f50dfe6c8cfc19939ae1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "96a34db53a5161686c72d69b270b5627206e7ca3072ebb02eb5f0255c6b7e3df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb4ba548df5e625717193354b6c782bd405f565e7fe1eb6287413f23fbb49074"
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
