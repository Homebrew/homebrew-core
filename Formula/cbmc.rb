class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.72.2",
      revision: "dcf0287060e133b7bc1a3a9f3287ec1dbd7837ef"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "753292fe6e77dce01ef5199d8ba54ebe5d6887e7569ccd667e835e7b5ccec0cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66f14b3a6b1538887f0db46a3c2d0812f6607a5ec6c1ae7f4592d8211a1bbd48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec0180d5fbbbc0a6691c661cbec7cf6741fb55357facc026f2f3b145cd3515fc"
    sha256 cellar: :any_skip_relocation, ventura:        "a10c14acdd3b8cc2a464d5fb7523e8966732a1926dc17f8bead1410eb4a71b54"
    sha256 cellar: :any_skip_relocation, monterey:       "f85156f15f6019e281a39edb12f7df45c5912d075ed217899b904e89771a747d"
    sha256 cellar: :any_skip_relocation, big_sur:        "48d7e57c32b700b159d85b40be07b4475541b005421c372b82992fd63b831cc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ed63bf71a42b817b8968a900e81854f22ae0245c5c0f4209eca988cbde5fbb3"
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
