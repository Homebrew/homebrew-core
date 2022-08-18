class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.64.0",
      revision: "8fbba35f27b9b3efb78f3b875ba27bf4ea6fe641"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40fef419615a370f90e1668bed6217b79e67ffc97e699ba70795fa607ef7fc4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "866d3bded05344388c0cb3c6ce7a1b80548f1c9abd6829f0ede2fa2ed1b03840"
    sha256 cellar: :any_skip_relocation, monterey:       "78d3069a896d10bffc1513507f2eb21a860d91a38c3abd0d173338a764a4aa58"
    sha256 cellar: :any_skip_relocation, big_sur:        "f31227b503bebf2f35a5999c13763ae99902b0808c3be60d7061cda5cde5f387"
    sha256 cellar: :any_skip_relocation, catalina:       "72478717108f8050292e0a5f550ac9b5a9128cefdec87e740835db6e0b9ee9b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c288e771e63a9d7f5369e972b353db58dc90dba3c6d89ab1eb02dfdf59407593"
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
