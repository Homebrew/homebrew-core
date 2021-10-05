class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.41.0",
      revision: "a76195a1437e83bdfec3df46aa738ddde4d86ad2"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "095f242cf7236399d0d7818b1e0b259c696449bf529fb1d8ba9647490d00b8e4"
    sha256 cellar: :any_skip_relocation, big_sur:       "99e2c8d8b7ea9541ba9ad79c99b2c82aa8a74c1f5ef4509f16d3b217513dc87a"
    sha256 cellar: :any_skip_relocation, catalina:      "8fb7438030905bd3af84b626639c17a8256a9d5606845a9b0c3dba36eff2a9ea"
    sha256 cellar: :any_skip_relocation, mojave:        "38b0dda92c87434eb32643bf9226b7be76113c894df89f08a2f83965d702f1fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbbf864c8fd36d0c45f3deacc0a0bac9e38b823e8bba9629e17cdc48a0987880"
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
