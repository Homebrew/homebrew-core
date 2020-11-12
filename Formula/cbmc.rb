class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.18.0",
      revision: "7ff70ee00d85ff9d84c2534db9b975d8e04d4559"
  license "BSD-4-Clause"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e24d5d6bc2f1af317959d13447e97801b6e034c658d6ed490dfcd5040e3db509" => :catalina
    sha256 "f4769ed5705aec6395637c68fa9311d3032b392e29fc1aaabae469aa238f6b35" => :mojave
    sha256 "56da860a6ec963c65c07bf83da13df16dd1141a22123ef42c4d842449c3922c3" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk" => :build

  def install
    args = std_cmake_args + %w[
      -DCMAKE_C_COMPILER=/usr/bin/clang
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "cmake", "--build", "."
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
