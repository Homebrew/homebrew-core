class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.20.1",
      revision: "a9a3644e9835addcb6fce6a2a99d4995139207f9"
  license "BSD-4-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f7427e791053c7f6bb7f05b10a302ba5183953e04a49df2bf127cc7d7fdbb12" => :big_sur
    sha256 "2eb31fc07b893643cb7c9b5c9138289a8648fae52676d084def12ff46bd55b34" => :catalina
    sha256 "1096c1a238edad50302b304b2266cc276e760c9f52f9865f66bfc8786a8cc0c0" => :mojave
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
