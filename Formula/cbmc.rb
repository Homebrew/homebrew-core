class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.14.1",
      revision: "c21ede2ef8191facee70260f97ffe4ae5d954143"
  license "BSD-4-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "703783debd704d69dc6ec9f083decd040115d8e0055194546957f5b96561f638" => :catalina
    sha256 "ac256c50422ac141f1f997da92a9a6be9859e579c5300b0ff4304bae3dfcab90" => :mojave
    sha256 "74ecb73f2cf558299e3577379514ba9bad66e4139a601213d6051764acd3f5df" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk" => :build

  def install
    system "git", "submodule", "update", "--init"

    # Build CBMC
    system "cmake", "-S.", "-Bbuild", *std_cmake_args
    system "cmake", "--build", "build"
    cd "build" do
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
