class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "5.15.0",
      revision: "94fb414c0b2dde60e000cdd687c12e4590f9a51f"
  license "BSD-4-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "b3ce4e58594ed53b480ee5345e3e137fa37604c099fb414ce5cbe135f8fe6039" => :catalina
    sha256 "7187b825e9be22af88160a43addf37679a39d494a321f7bd644b152d7bf5cb27" => :mojave
    sha256 "8de17d6c327221327a98195e866e711b87b53829fda93a0c2bb9fb461ef62378" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
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
