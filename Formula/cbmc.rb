class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.60.0",
      revision: "026931f0c5892bb5037299fb1afda38632f2e050"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be27b095148e4870af7cdb6e7b4709e88f831ec73e1769e7781242971f098316"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8bfc1f074842b8b2fd40323af2bfdf2b1a9bf02e9ad2ad5fd66402de9f7f9d8f"
    sha256 cellar: :any_skip_relocation, monterey:       "7f5710ae2d1cc7089de8493eb248e031ee748c2ec8392fb2422b05bca2b4e199"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ec886e503579fdf2ce45dccc15d5e3c2bc91741d140bdaa36a1aaf9a4f1c059"
    sha256 cellar: :any_skip_relocation, catalina:       "ec3c098c1bba2122c438d4283ee075be84e965ad9acd096ea58470d80596c72f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86752f1da3cc8e8c8be30914ae128b5e05663a7155c3e4fc88bb2f0993ac7cc4"
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
