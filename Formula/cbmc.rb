class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.25.0",
      revision: "947fb8fc11d85c21593c3947701babef78b48b45"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "b2c269baea34609232a5125329299bf23d9ab28c62f2ba957042915035fc9d2c"
    sha256 cellar: :any_skip_relocation, catalina: "efd67168971fb8bbba7b551ef47b3c9867ab65fda675495d00a449e84ce8bcb0"
    sha256 cellar: :any_skip_relocation, mojave:   "4cf313ef11fcab6643a30f0f7b9d3ff5bd6b8cd356c8dc940049deec06017e1a"
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
