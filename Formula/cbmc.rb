class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.79.0",
      revision: "4af9c8a54867ca76e8c22d218d4eca2eedbf8d5f"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be173d332a7e2e72a2273afb9c3c6216c7c7aa4b0edacf0e3c409c6ab4227986"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e35093624b33a6ac96e3feb9ee3a3825e948fa503c8c9a39c8748f78bb82f555"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "087ff26ff208888f73db435dc12d84bbf279f3318e70f3b7dd78f6705a3e3067"
    sha256 cellar: :any_skip_relocation, ventura:        "a19b5ad3ebe762e15ca5edf6d1a57fb597ed0b85b1d47269b3b2b6bcf85b7752"
    sha256 cellar: :any_skip_relocation, monterey:       "ba00ed3a9068ca7b56433d5aa5c02867f1666296f689daf83b6d1b99ca9914d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4bbffde31ceda4e3411aa109cf1d573af3e61f750d325466b8c1f72f8ddc059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80409e3a26b297dc82f386f204460eb22a9db69b8d4c660dc17b94427e71f850"
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
