class Cbmc < Formula
  desc "CBMC: The C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      using:    :git,
      tag:      "cbmc-5.12.5",
      revision: "b3a6cc4294136c1d2710f64ce5014f9043c92c95"
  license "BSD-4-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "2168ecf10a53b43349471559dc48d4b5ff57f260d64b1b1b74a400d45e9af881" => :catalina
    sha256 "3b85cdef01873900c6fe20976dbf0479cecdc17ef07f839585577865efbb3672" => :mojave
    sha256 "769326912492922c9dd6dbd6573511e8ad281806fd6eb450ff8b863898030b22" => :high_sierra
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
