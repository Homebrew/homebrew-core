class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.72.1",
      revision: "de504f532f407b51fcdb9ef7ec61b4bae4fde49e"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24d813de8d7c7d463f864fc5e0959b720b5352d87c658edc779dbb9754060205"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54306e131363082cbbf4a0912d8dcff695543f1ff38e14dd014f7112eb8cf422"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0875eba861ff43c0c80f3804e7302b71849b8162bbe13a940f5a7a3cc157f67"
    sha256 cellar: :any_skip_relocation, ventura:        "37a064fd8540a13b72696249f6096080374a98ef136190061547ea692973d18d"
    sha256 cellar: :any_skip_relocation, monterey:       "01901ba5c69c0d96698d37e5dd542ae00f19801ab1de05a783273de0be98b1e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "683e6209fd73ae3782db76e13338b6b06f2b9e183ae7df04fe378cb116d9d362"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d26f95ca5704ef52ddeda869247d164ec0214a71543d8a4faafb3a65edbfcb0e"
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # lib contains only `jar` files
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
