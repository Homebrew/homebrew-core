class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.30.1",
      revision: "be9b3b4161e8a81a0b31ae9357b5b285a4968199"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "a8868ba0f4c736e005f733c18013cd2aaa057175c2f95be7e5c5ac8297c95353"
    sha256 cellar: :any_skip_relocation, catalina: "54276ed321023ef2f42b0b83a12564fe529024d66570b71c8efdf964cb7d3f4b"
    sha256 cellar: :any_skip_relocation, mojave:   "c92e5773482e6c693d211565025b1d3b11e2c88f33ddf3a49aae35800715c69e"
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
