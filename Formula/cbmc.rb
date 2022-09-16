class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.66.0",
      revision: "c3a57ec2671f603f81ae2cd593edef1ae1abcf52"
  license "BSD-4-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "681196a0001f7f6707163e620c09a1ecf4436d6ba5c64767991c16fea3a2ff0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a88ddeabf9a9a2f9652f032a8169b74dd2e4a4e321515700f1ea19a56d58047"
    sha256 cellar: :any_skip_relocation, monterey:       "373f656b44f4aa23f054a73e12e6fced32852cbe3880b6e7b46f98e3fff5ae84"
    sha256 cellar: :any_skip_relocation, big_sur:        "54aad00c5ffe6de24513a5de302400c02fbc690ce221261a491f7a1585c97d65"
    sha256 cellar: :any_skip_relocation, catalina:       "be81f9eac4eb81e34ffbc549d32496e50f16f276a8f30adf17ee74a3b3157464"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d707e99de9e978ea6a6e676f7b7a36cb4ed56dfb7fa5b0268ae999be8c3aa26f"
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
