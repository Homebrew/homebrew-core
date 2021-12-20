class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.47.0",
      revision: "95d8c91c4a5c7823bfb0caa35fc8ccfe03d21243"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cef107ec905487cd7c9c09a1b952cfe51af65a21e324bfda5d0ccea0453b2782"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f990ad991fae3ed34c0460c3822831cbbf0b05557cf22f60014975a34914d6ed"
    sha256 cellar: :any_skip_relocation, monterey:       "c6fde27475b1871bcc07b96abd94eff247a080897cc7e299e613f4420a9d696e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a417fa5ddbb316b233233595ca9ba9dd2b33b19548acead0b3f0e2e72062f4b8"
    sha256 cellar: :any_skip_relocation, catalina:       "6413586f46c9aa3657aa328d91979e8765d10e8d0f3f5f0c1fb91e20ce6e71f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc8dc760814cb2a1dddfdf46dbabd92511b17faa8f8ae1ea2b445979b43d33a1"
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
