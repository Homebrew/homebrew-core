class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.37.0",
      revision: "e4369b6241b7f74c8bb8b3145cb3b7c38e3bc369"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4ae8055b85a0f28b3e88e31474c250c4266e642f42ad711860c118659362830d"
    sha256 cellar: :any_skip_relocation, big_sur:       "aece82ee5cd4d18a970a72be1089416a3d2795f04927b1286aadd794a44f132d"
    sha256 cellar: :any_skip_relocation, catalina:      "05947f565f12c98b698ba8e00bd341252a12df3f9ae6773ed0523675fe2d3789"
    sha256 cellar: :any_skip_relocation, mojave:        "1f53a8118ffcca140dc0109abfd6ed04b06b0d49b9f547e9c7c957c9a134a4e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59921b3a80254b47e2820665f5c48ac3bccc851e63e3b8e24c350e4be1c2e6d6"
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    args = []

    # Workaround borrowed from https://github.com/diffblue/cbmc/issues/4956
    on_macos { args << "-DCMAKE_C_COMPILER=/usr/bin/clang" }
    # Java front-end fails to build on ARM
    args << "-DWITH_JBMC=OFF" if Hardware::CPU.arm?

    mkdir "build" do
      system "cmake", "..", *args, *std_cmake_args
      system "cmake", "--build", "."
      system "make", "install"
    end

    # lib contains only `jar` files
    libexec.install lib unless Hardware::CPU.arm?
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
