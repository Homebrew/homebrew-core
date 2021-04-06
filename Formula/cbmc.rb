class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.27.0",
      revision: "a70e82e33b1e71f86be55762d17d02b92739b2fb"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "b15489998ca770bd0dcdd6c4a882000a0ce11a782622676e222a244980a4a395"
    sha256 cellar: :any_skip_relocation, catalina: "f356d95a86cd293f515196ba37a94f550a90cd3a32ab2b33ac1023f891022167"
    sha256 cellar: :any_skip_relocation, mojave:   "ca4b0295201fcee3490d58c5bcafad887347e946c8288ff319f7ccc8808ed5fb"
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
