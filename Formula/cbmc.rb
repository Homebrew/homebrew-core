class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.56.0",
      revision: "8a41865d97e180e3ca8e4049ee7978b07e428359"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "664df3ca30089ae4bac3f60d032c7228e3e0650ec6e3fd884b31f78cd255ebff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5a4ed20848bbf1b8ea7b8c2b00d1fe90c16be79f5f0a8c84f30850328d037a2"
    sha256 cellar: :any_skip_relocation, monterey:       "f2ee5814e34b8cade90f1c4484f65de69ae17f99f29a7ea847cfd10834d130f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1377cd95a1346b09a76cdad1d17cd81334ad543ee24f5e7cf5c3addc8990f63"
    sha256 cellar: :any_skip_relocation, catalina:       "3f47a09d52ff83b488f2a37b4f388106830aff99d754bdb58b42317e1d1ced5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6a65f0bad758a8cd1f54fc2ccb6b3e21cdd1f227846c969502509fa1982b121"
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
