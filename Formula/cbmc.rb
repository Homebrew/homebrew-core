class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.85.0",
      revision: "2830a3bc8e1e8033ddd74cfd3dcbe1b7cceeeacd"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "369801aeacc532c95d6fc2fa8fcaffde74d09595f1a2d675193ec3700359a2a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "285b615ab53d7a86ce11bb2b5f6a9952bb0a1135d7d82ec264db0aa3e2085d6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41f7f79587acb4cc63ca7a694aaff087ec47225b4e54cb92323d54b6ac839046"
    sha256 cellar: :any_skip_relocation, ventura:        "9cf5d6743db4624dccc70374ea87727daeb7a8b13a0e999f605b5d07000d9102"
    sha256 cellar: :any_skip_relocation, monterey:       "42bb10c2158c62abe7e350dffbca0866449ad837c44e66485762f08b38dc8b62"
    sha256 cellar: :any_skip_relocation, big_sur:        "e101b57502accfa61499a94daf10eb55e1dae2aa012e4a26be3ec2b37bb4e764"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc695a1ef6b957d27be44ffe93e0000698c60b1bdb80bbbfb8dddee3f01c5572"
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
