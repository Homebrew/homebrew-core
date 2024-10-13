class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "22a1696ce880b34ca5ff949b6b5a42d4e370502e0b40b59eaa679eae13e45363"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66adb20a7487209047ba4a832f3ffa48fbfbd11648576f1e44a36d9bc323b000"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66adb20a7487209047ba4a832f3ffa48fbfbd11648576f1e44a36d9bc323b000"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66adb20a7487209047ba4a832f3ffa48fbfbd11648576f1e44a36d9bc323b000"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b580f40bd6c84a9ad3e1510b991c43d44bd7af9fd8c24a2c09e1baf422f9a9a"
    sha256 cellar: :any_skip_relocation, ventura:       "2b580f40bd6c84a9ad3e1510b991c43d44bd7af9fd8c24a2c09e1baf422f9a9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cef9008c232f3d5b648fa4b3450fa02747b77e42ad0d283c231feb94752c6858"
  end

  depends_on "go" => [:build, :test]
  depends_on "git"

  def install
    inreplace "internal/linker/linker.go", "\"git\"", "\"#{Formula["git"].opt_bin}/git\""
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"hello.go").write <<~EOS
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    EOS
    system bin/"garble", "-literals", "-tiny", "build", testpath/"hello.go"
    assert_equal "Hello World\n", shell_output("#{testpath}/hello")

    expected = <<~EOS
      Build settings:
            -buildmode exe
             -compiler gc
             -trimpath true
    EOS
    assert_match expected, shell_output("#{bin}/garble version")
  end
end
