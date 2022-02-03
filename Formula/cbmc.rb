class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.50.0",
      revision: "05210b57773a6429cc183f33226a9d780c6f8757"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84adc1b16c1234cefe0ba3bbd1fd48e129984be87affeb94b1f66d5deac94d22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da46465f9ab9970db37e63ed8cf58ab15527133bb21e6efca95432229f62d64e"
    sha256 cellar: :any_skip_relocation, monterey:       "1c41e5418a42bb8821090916795db5b4bd4c0ffea97c15a1fb4aad3189ca302c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4b7e99f51a4816b06fd1e904f19dcb14f6ddb9e3df895db18a960d40d645d48"
    sha256 cellar: :any_skip_relocation, catalina:       "16c3c16e7df29f3ab9cd14a502c33665ae4b89f4e3096200ef50cf1754fb3653"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db712d72221d59ef6132d5fb5a2a1194721502b3875e4a05638da1321ea9c991"
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
