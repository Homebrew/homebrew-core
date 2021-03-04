class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.25.0",
      revision: "947fb8fc11d85c21593c3947701babef78b48b45"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "d6abc76909a598f8b5234d1d12a90c3b6261a108763dfe9fd71ced5c9e3cb168"
    sha256 cellar: :any_skip_relocation, catalina: "de375ca034bfb40e41c8d3533ffd432ae753ae0af83aa5bcd32c0cc2761fb090"
    sha256 cellar: :any_skip_relocation, mojave:   "873220a188a4b3bf3215d7d0c998ca2030b8b9d9b1cdabd35a4e7e9956fcbb2b"
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
