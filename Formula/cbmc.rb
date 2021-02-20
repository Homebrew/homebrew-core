class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.24.0",
      revision: "751c98667b8a38062a445af236a869cd0399f14f"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "6ecfd9bc6f6c31c3bab8fb651c328f9b9ed4a08db6eaf475833f2128a11de24d"
    sha256 cellar: :any_skip_relocation, catalina: "3878729f8974a44072ec18d0773b6ad177867948a7c8dcb4d72832b97b4a70df"
    sha256 cellar: :any_skip_relocation, mojave:   "112c278f2e7bdd77d8ff48640f8e8b5713786dc8466e62501001b8b95ba65285"
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
