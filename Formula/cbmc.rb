class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.28.0",
      revision: "a341c11b2e1a5b31c070de19254e954b7ce9be48"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "2d953994945e3312dd69f745bdea876627618e21d920de8ad2c02382f5e733cd"
    sha256 cellar: :any_skip_relocation, catalina: "408f5c841ad6515f4137360492e5158fd024006a2b85f13626d19d7c129ada20"
    sha256 cellar: :any_skip_relocation, mojave:   "262a7ae03e1666d8d09318d492f3bb62d8a4ca06effb48806f842d0a844417d7"
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
