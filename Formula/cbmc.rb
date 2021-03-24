class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.26.1",
      revision: "f8997542ee7f7f52ef21884feff19b682762c025"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "fe72fa8bffa689d6f505e446ff879efc888e6be1a84af7f27e019b81ea1637de"
    sha256 cellar: :any_skip_relocation, catalina: "3a8b0c4917e1778fb59d40b504825261bbf6fd8cb921ff2bd28f6d284137e748"
    sha256 cellar: :any_skip_relocation, mojave:   "70f750df18ebe14f668cdb0547ec6295cef0e73ba1efa8ff553276a9b786c38b"
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
