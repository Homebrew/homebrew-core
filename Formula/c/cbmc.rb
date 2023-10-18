class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.94.0",
      revision: "a997e322f16566986ec23c4824519c2fee9a8cc8"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9269fcff646962a9a56d21c84bf8702b8a68272afacbfee425f32cee0402e7e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50396efad00dd3462fe21f5df7b3eac8ac2e2984fd84673aa340fd92df825f2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "677a1f76f185e871edbabaa729896429625a1362a2fcdd6ea21a6eb9c55614be"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9bd5399e771b0f67fdef2f7a13a54776eefc99c208a5f2c6fc5cbcf9e058257"
    sha256 cellar: :any_skip_relocation, ventura:        "c4c9ec79fcfc5d319ad3b8653528f650ba318dc50c468035ef71900b1a74cf3f"
    sha256 cellar: :any_skip_relocation, monterey:       "092dc37e4edff7c4618ce020ac748b9a6d58b54c2f76914a6a4e45e740d6b90a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "617948ad68caba4a450c5a0cb23103cbff8d5d6c12f21d3e1401ebd9daf7ac26"
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
