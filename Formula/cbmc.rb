class Cbmc < Formula
  desc "CBMC: The C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.13.0",
      revision: "cc4d1ac6cf104139e00a9a7db8375921a32ef16f"
  license "BSD-4-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "2d0c141402bc0f59671dbd1d09eca4b34520f6e0e56762f271592b8aeeab91e2" => :catalina
    sha256 "ff0c23396e8bb598daf29eeb139cf3ddc1f3db759bb210620006ca963c2a9da1" => :mojave
    sha256 "84c1e56a1e57e0bd7da14d7d03f70262645e6852478f3798d603c5c1ca67d33f" => :high_sierra
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
