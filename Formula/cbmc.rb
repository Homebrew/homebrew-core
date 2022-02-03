class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.50.0",
      revision: "05210b57773a6429cc183f33226a9d780c6f8757"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17a1889e5e38964247fedfb3aee1a6ab60696e4ceb79575277298cc22b4ebaf9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a3b17a9335f8a6278090929663cad1fc0b731b88e3f6913e1720e8056d4945a"
    sha256 cellar: :any_skip_relocation, monterey:       "f3a49f60b8df7714b281fdc146ffeade77d5353d1cab5aca6ad93d0e66263063"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c49b127d6acb7f360a6009759b87ceb9e552e00e96c0a625a07288b53f86d56"
    sha256 cellar: :any_skip_relocation, catalina:       "2a18c5db92ea3ce3ab710c02c290650f8e378d52c677e3a388d1b3ddafae2e09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35df9b58d94d8359c37f835c731c4400b04e6ef14f3b97ab7c23952b5f8c73a2"
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
