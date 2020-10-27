class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.17.0",
      revision: "1c4e0c495dab131f88f0ab0710c3bba4e9c61097"
  license "BSD-4-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "bdfdf7ca5f685d13fed0c73b391328ad1c95ade0c8778bb2c2dca3a6a98a31aa" => :catalina
    sha256 "0f6fdb19e315487633cb4526e7c52d617da9264f96d7829548d3d0d2fb8950b0" => :mojave
    sha256 "b3dc17e74dedc5ad60e909638077ec790cbd091283057cbf2df96f44eb97b3d6" => :high_sierra
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
