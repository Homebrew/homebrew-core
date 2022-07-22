class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.62.0",
      revision: "64034e0d47f5d79b67fb22310a0e785469d24f01"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d375bb18ae140386579c98dcfa47c650690ce927b98ad1d886013a99bdbb126"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c7fc52c64ad41c67bf53734d634b5e679d0c3555d1b962ca00f7a08f9f50e04"
    sha256 cellar: :any_skip_relocation, monterey:       "43cc2245e1b041988733dfc0cef7647ad52b524443a6ed5a4d86fa30a3aef69b"
    sha256 cellar: :any_skip_relocation, big_sur:        "67e0f152bdb1fbdd0495212bfd26ec456aaedf16292a4070465c87a7034a77a0"
    sha256 cellar: :any_skip_relocation, catalina:       "17824331878a73ced0d6b05ac8037d853bd2d790fb0282127ecbdceaa5f2df59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "579d060e49739a22e5461d211732342520ed5184f589712b5cd4402aa64a6a21"
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
