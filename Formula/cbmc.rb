class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.35.0",
      revision: "7e291a5232bf0dcae9feba0281d371b83491d832"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "82da4d0340b92cec36d9978e24818c66a5a70df14c6933fb21271c1a10f4bac8"
    sha256 cellar: :any_skip_relocation, catalina: "af5e7c5e7c0ef5009bebdbb11077943567ff7b0d6ed395483e8870eea1964fec"
    sha256 cellar: :any_skip_relocation, mojave:   "a2e7203419d8f70291f0c9e2cb16cd95601abebfcd1180008f0477216240ae8f"
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
