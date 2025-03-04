class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "0eb231e6ad91793f0fcf086fb57a1654f0c2056284a79fb12ac955ade6791737"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61a5d644ddf1ac9b3b22c53d4e57f555fd58a63866fd0a92ef39a61d18bb266c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61a5d644ddf1ac9b3b22c53d4e57f555fd58a63866fd0a92ef39a61d18bb266c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61a5d644ddf1ac9b3b22c53d4e57f555fd58a63866fd0a92ef39a61d18bb266c"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd37e6706715d6380b03b0e863f8a63afb3a14412a384f010d33afb339c93ef8"
    sha256 cellar: :any_skip_relocation, ventura:       "cd37e6706715d6380b03b0e863f8a63afb3a14412a384f010d33afb339c93ef8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27f096cc5bce2fd93f55a43183c9afd75438acfe71e0b01219552a8d9b9e8280"
  end

  depends_on "go" => [:build, :test]
  depends_on "git"

  def install
    inreplace "internal/linker/linker.go", "\"git\"", "\"#{Formula["git"].opt_bin}/git\""
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"hello.go").write <<~GO
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    GO
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
