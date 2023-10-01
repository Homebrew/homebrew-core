class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.92.0",
      revision: "671e46a67401970aacc937f9c9284ae845289471"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c45395cb1fa92165d1e54953c50132d8e4b728f5889a37e9904b039c5447e9f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7e5662905945a8974713bce287a9d00703a30ae3ef5361b0d9e905e5ea74993"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "219251de020f2fce4a7263487422b34a140922fdf521dce02a632d81520855bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d0c0ceadb212c2e8b4c8ed84c48f958e567d7ef4cef0877b85929a050a5c054"
    sha256 cellar: :any_skip_relocation, sonoma:         "03ea1ec068d0ea01d87ef56f7690fa45145cbba258c16eb24a4a6037225a0dd7"
    sha256 cellar: :any_skip_relocation, ventura:        "eec05207f1ccdcace1cb86836fd9d07ba2ffd3d50552a45e2e17e14420a54f53"
    sha256 cellar: :any_skip_relocation, monterey:       "7aa6d14a0d00aa5cd08b941fddc773f409a075594e0439de18e6ec893ec4c08f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f0a1497b169d7efc90a145f7097b2346e914f0254ff2fd675ea6c58e31486f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a88cdd3a9bcc082b1a55658eec0b32303b49110108fe2c174a0dbfa37343892"
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
