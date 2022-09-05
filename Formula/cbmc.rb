class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.65.1",
      revision: "f680e0fa669b248db6e103dbafed67a2d3f72807"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc7dc15dfb7ca105b73c7eb6a441b19ac6a671c2102b4627f72a8feec7652dcf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5f668dd890e98d8b330f0cc0cf9bc90cc4222d9d111d61dbaa81dd5e40d4b1d"
    sha256 cellar: :any_skip_relocation, monterey:       "d70a12622351bc9a4aee7b1d35d10c9f41fd47ba06451f3b85e18505e0f1647a"
    sha256 cellar: :any_skip_relocation, big_sur:        "13fabd3c4a99e973877d94d9e0fb33d4293981777fcf198926ba186c16410b1f"
    sha256 cellar: :any_skip_relocation, catalina:       "9796ab04f38eec5173c8f15e9b889566e716ee4182b583e5aa3ff699a2f57d8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc8a1432cde2fcc3a51689629b1bc493f59a9185f9036f8eb351da47f060ff53"
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
