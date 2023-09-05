class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.91.0",
      revision: "3e3ba26f238f4bd27cff3923039dd2d21d6d7328"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9fae71d2e6ae188ad7d0dc815ecea468224502adffbbbe8e9f32b536484e4fb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb9d44010951a95e1cd8603177a63c579223a8e226e569ee20b45bc0372225d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e7342771016f8a4fb977edffb504825157d4440afa63472ba46c508f88a0fa7"
    sha256 cellar: :any_skip_relocation, ventura:        "13401c95bb813f7b92ec65a3608b88ac9432c93f3a1b9a7814aa29d9652eed7b"
    sha256 cellar: :any_skip_relocation, monterey:       "599a156be15099dee52c3a3c70eec92aee74f50aecbfb2076ca79bdb00f43462"
    sha256 cellar: :any_skip_relocation, big_sur:        "914bba7f3b3dd3ffd122660e4c7fe3e8c64c9374aaaecc088f9c125e72b962aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "deed3e87baab03a14c009511c42bdb9f4b5b5dac111b3644f48feda7f63fe55c"
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
