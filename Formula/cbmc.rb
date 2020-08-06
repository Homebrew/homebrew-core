class Cbmc < Formula
  desc "CBMC: The C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      using:    :git,
      tag:      "cbmc-5.12.5",
      revision: "b3a6cc4294136c1d2710f64ce5014f9043c92c95"
  license "BSD-4-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae760e8d4ebef48795153e008b9f973280fb9012ee0f187a92ba1ebd5f7176e0" => :catalina
    sha256 "fdb290684027c7732887d5735d133d91787488feebff3febfa5ea52c0e1956c0" => :mojave
    sha256 "3d35aded8e36a10a7a400b8084c7d76c9557f4a6a8327adb09c06ecd02209370" => :high_sierra
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
