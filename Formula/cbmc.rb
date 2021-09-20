class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.39.0",
      revision: "4fd1a8dd6c4eca3498ecfa9cfc533edb256d2ba4"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "83e6399a382670759dbe25376d39309153394541b693d960b2782dcfdb446e22"
    sha256 cellar: :any_skip_relocation, big_sur:       "8fa637bb5b7196a033ffab22b0c990bc4ce1df436d3bf9245b574c89788f6011"
    sha256 cellar: :any_skip_relocation, catalina:      "8dd7e6dc6d426549ba53432026d36d5b11c49533b659f91e40bca531a0d416dc"
    sha256 cellar: :any_skip_relocation, mojave:        "a3487712a1633ece2e59a046c3e70555daf10d34056602da9bd69a5229d1615c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6a6ddad09e6789292cc639e37337eff3b4a0ba119f027bbe9a1649ee4abd61c"
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  # Java front-end fails to build with openjdk>=17
  depends_on "openjdk@11" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("11")

    args = []
    # Workaround borrowed from https://github.com/diffblue/cbmc/issues/4956
    args << "-DCMAKE_C_COMPILER=/usr/bin/clang" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
