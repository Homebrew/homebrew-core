class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.13.0",
      revision: "cc4d1ac6cf104139e00a9a7db8375921a32ef16f"
  license "BSD-4-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef89e68d15a3a8d58d10691881ce73ad2e6bbc6c739e713ea08571859c106c12" => :catalina
    sha256 "521ca3a36abda9306c19a52dd032e60d2e10ad0b9f95a86c397bf09d4be63a98" => :mojave
    sha256 "31b58b6ed75d6a3c3e8d31ecf03a7b7facc54bc357ba2581da3b1cc34d98b8d2" => :high_sierra
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
