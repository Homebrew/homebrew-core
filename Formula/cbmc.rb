class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "5.22.0",
      revision: "08c9ae9e571495d8ab010ef1ce6eff63b9561f43"
  license "BSD-4-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "4217aaaac48c136812d950c747dc06e85a865a4c369067199eb7f3517abb9ee2" => :big_sur
    sha256 "c8bc5ae68b0702aa5efa2c1861285d95bf15d96eeca92966b45cd776d39f7dff" => :catalina
    sha256 "3ba91c12f36d1498792c91900d12fe19f62ecdab762ef437a0aa2da280f50fa8" => :mojave
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
