class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.32.0",
      revision: "556b4325b12c00a071e6efb33caadba0f14a091f"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "15727392810a0b6ccbf37cdbabf79f18166ef676fe8e7a60609d2fc358273253"
    sha256 cellar: :any_skip_relocation, catalina: "e2fbd9b81191ec744c4f30ac404df0b91269d2031a03af5af3f6b04587adc868"
    sha256 cellar: :any_skip_relocation, mojave:   "706589bbc34dc86a9bf1a2cc6e9d14d3ce423ada91bc2c633b9b4b397ed82586"
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
