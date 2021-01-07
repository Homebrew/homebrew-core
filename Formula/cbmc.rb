class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.21.0",
      revision: "c7e3c5d7e81adf11b9456a0bea9ce14584304bf8"
  license "BSD-4-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "e32d46292d671285d968f872d2e098d735335bde9f3e3267fb5f569512656e75" => :big_sur
    sha256 "8ef763d09c85b4e1e7b3006004762c02deb5e4d7da28dd3afa2c415b3fdcb014" => :catalina
    sha256 "556b07ae890f74baef162eb91c7b9b85baba673eaef6187ab7374e6ea99e7fe6" => :mojave
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
