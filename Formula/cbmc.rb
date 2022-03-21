class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.53.1",
      revision: "4987df3c306b6ea9e26933aa240fbc8a62fbbc7a"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d346c09394cfe3711dd5ada08338c2cc1886a2c4d789eb70f9600a63361fcde"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e9e3e769dfd1417f4ad8e0822770c654aabbcb74025377813fdb9d13661e7c3"
    sha256 cellar: :any_skip_relocation, monterey:       "2ced9dc21f4f69bb37a7ae299e38dc8e06fd41a870d4ed0daf68911db2cb2b3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d3b4d9f1539ec7d5694e741a02216adfc50e55d51bc4cec69957b0ae2bdb6ac"
    sha256 cellar: :any_skip_relocation, catalina:       "a98eed357c861c8b82246b5768be2b09c07c32a9528666ca51d71146477f454e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70b111764d32c01b78863c7d01e594d62105986d6301466261f3b2fe9babb2ae"
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
