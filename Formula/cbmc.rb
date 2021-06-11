class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.32.1",
      revision: "4dc2dd5b106c19c11bba9a06de7288946a8b6dfa"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "30e031a1d64f4bb1c302d3d2efadb69c4503507f3c685a96fb589975da102db1"
    sha256 cellar: :any_skip_relocation, catalina: "efb60689451690324ae4fc461071b026a555a2b2dc07eb3efadc1001da047734"
    sha256 cellar: :any_skip_relocation, mojave:   "81d2dba41c51ecaf93670b43b092b24caeb883aad63a58906483211c21428554"
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
