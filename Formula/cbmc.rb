class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.34.0",
      revision: "5b12b641019c9de253014295f8556d57a76e6b17"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "056fc492b03722d78de3b0d53d33b838d3a4c58a3d4369f38c271258b64cd8e1"
    sha256 cellar: :any_skip_relocation, catalina: "16a3c14b58aa88328b695ffb5e14b1c98182956bcca56367d5475be6df846ab9"
    sha256 cellar: :any_skip_relocation, mojave:   "31c76c05ad7d37f6096e5e9bc31d2004a9882b7c186f012f63134e7033029a07"
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
