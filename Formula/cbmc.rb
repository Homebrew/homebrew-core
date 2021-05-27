class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.31.0",
      revision: "c21dfd987056cce3b133b4a01e00f2260249ae98"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "1deb014e01b51f9c3157c14f8ba0826804c87186a85b8f4f5b4b29f80ad63607"
    sha256 cellar: :any_skip_relocation, catalina: "1c465fa4d338cbaef4ae192b67e1c71def8638cade2b1eebe74aa62dcb43e312"
    sha256 cellar: :any_skip_relocation, mojave:   "b72a9039ff4e5bb3ddafc669e02c5f998aff672153f36badc4f2da1039f492d7"
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
