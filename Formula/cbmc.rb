class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "5.22.0",
      revision: "08c9ae9e571495d8ab010ef1ce6eff63b9561f43"
  license "BSD-4-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "980ed108f3bbdb2cd9e5911d28020c9720a5a23968915a6d70fa142cfb2c8793" => :big_sur
    sha256 "a277c6ae472142c60967a7ff248ffa5b8c6ab030f6b79e093142f237ea735824" => :catalina
    sha256 "05c6405fb07aba85223f028436f8b1bf9c6626fa867f8f381e9c2f0c10b1defc" => :mojave
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
