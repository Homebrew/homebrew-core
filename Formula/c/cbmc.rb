class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-6.3.1",
      revision: "d2b4455a109383562735cfb8b52ed8a6d2b6e197"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e50e314bf1f1ddaa9253d40c4dc70f3770232308dcab4295337661437b1460f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "133d3d72f113fcb12292e08a39d2449f16fb4510567e52d35e384142fe659db5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c06dea047e5c78eb95354b17dcc40cc59abcf9db38680d9ead760202501540cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "c45b99b6975d0f2fa78b5aed64751e58f12367aaa91edd06b34b86782b3b5c10"
    sha256 cellar: :any_skip_relocation, ventura:       "de04d1c43dc85344c103d79b1f7d143593122d86793b759328d57160b5d8a30b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdcfa01760c11979adb3ee153bd3dd67ea2df230e171ced004473999b05ce936"
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk@21" => :build
  depends_on "rust" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  fails_with gcc: "5"

  def install
    # Fixes: *** No rule to make target 'bin/goto-gcc',
    # needed by '/tmp/cbmc-20240525-215493-ru4krx/regression/goto-gcc/archives/libour_archive.a'.  Stop.
    ENV.deparallelize
    ENV["JAVA_HOME"] = Formula["openjdk@21"].opt_prefix

    system "cmake", "-S", ".", "-B", "build", "-Dsat_impl=minisat2;cadical", *std_cmake_args
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
