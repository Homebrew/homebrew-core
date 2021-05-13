class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.30.0",
      revision: "800f24b50d472006988d918be14f0608f3a5487e"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "92a490ca4ad2cc9e1b247571dd3f230f01034eef64036b3eed264a1ad6d5fe4b"
    sha256 cellar: :any_skip_relocation, catalina: "b5063bb07e0a194a7184508102e4eba33cb0ac1f77a80b36632aaf0b42829b44"
    sha256 cellar: :any_skip_relocation, mojave:   "8115a1291c01f768a46908125638f7eadbf4e99437457cebc97348ccaede9524"
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
