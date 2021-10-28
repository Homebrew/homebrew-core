class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.43.0",
      revision: "07895efefd6780560dffdae10d83857714ae6b8e"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4a475b88cfe5109cade204b1aa3d3a94da072c933940e707ac4e7b58aa8befc0"
    sha256 cellar: :any_skip_relocation, big_sur:       "9319e8c5728afc2d252e65f634b1e44be9d875f0f40aa832496197340df3cf2b"
    sha256 cellar: :any_skip_relocation, catalina:      "deb588447c6c32249e3c6cb04e60f02c4544ca0b0eaa17fbf2fd8021e64c28a9"
    sha256 cellar: :any_skip_relocation, mojave:        "8f3e692925ca1e333ab6abab82302e31c186e625f4faac6463135bccd523c7b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5caf97ee9e51e98496c120bca1deb08c5b39dc4306fac10539b62a56180d53cf"
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
