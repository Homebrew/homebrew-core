class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.32.1",
      revision: "4dc2dd5b106c19c11bba9a06de7288946a8b6dfa"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "101bec975d907ce7675e1844121c814838c46d7a0c72cb053994b45a1f7ec673"
    sha256 cellar: :any_skip_relocation, catalina: "13a57c4eae4d02ff2ae0d4347eb2d51b66201f4142ce5f248c25eb32916dac8b"
    sha256 cellar: :any_skip_relocation, mojave:   "c1233e8290b552af6e29f7eb379cc1d485f117e1358611beb358e57e36abcaa6"
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
