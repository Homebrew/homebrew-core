class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.16.0",
      revision: "4451960f8b8172bc91bc8f1cc84ad78e05b12536"
  license "BSD-4-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "cbf5aa21b67d01c45c0fe817c11336cb5bd32cf30ca285248175813aaffc290a" => :catalina
    sha256 "f1c1a40101b5b382ba90eac40560380ddf635e62e4da1b974a580b4b60160e9f" => :mojave
    sha256 "ea860da5c47abe4b31d503c4c43bfb9ef51e7213346532996ff248816f277bd6" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
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
