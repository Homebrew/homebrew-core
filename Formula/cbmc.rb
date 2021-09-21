class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.39.2",
      revision: "8e4b5c6b4f13ca62fa8674eb006d16c8e4ba72c4"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6ac2f59cff30ca9ea729795eabba383866a6bcdcd2cd937dbff9c473e79ee527"
    sha256 cellar: :any_skip_relocation, big_sur:       "b3c88973e6a7d57e32c4356deeac8d48e92d87d0f210bfe52ae166a740d366cb"
    sha256 cellar: :any_skip_relocation, catalina:      "a7837f085e88d5ca2ad960cf7d834685c23f76b2597779bafeaf29aad3375cb8"
    sha256 cellar: :any_skip_relocation, mojave:        "5e7cd56621dd5c4ed5e66763b58c9acff4c0d51edb957bb0ad9f2aafa1c464b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2714976a9e7599eca161134ab9ab2ed21f3d9d1d604eead03f77c7cf7fba3be9"
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
