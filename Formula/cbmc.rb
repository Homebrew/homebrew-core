class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.14.2",
      revision: "aa5a40a395dee461fc082592529b3c0437e90718"
  license "BSD-4-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "684bb4c6e68f50479ce5654232828e82067542ef2f969644a8716d2973e8a210" => :catalina
    sha256 "9b500d47fed9c9179c5fac7468d173322aaf2ed572c1840bc02d362d4f8d9f0e" => :mojave
    sha256 "55a3b9044eb6f980356bbb7a0b472c23d2c477810dfc98c3fde4f761feedfdba" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk" => :build

  def install
    system "git", "submodule", "update", "--init"

    # Build CBMC
    system "cmake", "-S.", "-Bbuild", *std_cmake_args
    system "cmake", "--build", "build"
    cd "build" do
      system "make", "install"
    end
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
