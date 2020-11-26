class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.19.0",
      revision: "416b7449278454d5048b6d9d19c1e10936cbce7f"
  license "BSD-4-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b5eaa087d9c11e5ac8120362ebfe3d5fe76f9fd5313e21848929abfd0f516a7" => :big_sur
    sha256 "ed3c1e642156409d322f635bf7c140f6d7c7ce6958003878f4b02e9340515b63" => :catalina
    sha256 "b81ec3bb2734293ed39d0c336c1c6445b7d87032994e642ea7ff5b195fbe16e5" => :mojave
    sha256 "d7db72ec3bbb3f568e9ba432f5b146eb20d15b8a2fc5c4e3f9680d0d27852ce8" => :high_sierra
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
