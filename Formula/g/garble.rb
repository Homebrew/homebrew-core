class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "22a1696ce880b34ca5ff949b6b5a42d4e370502e0b40b59eaa679eae13e45363"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b43364e3519406a6d6c4c66255c369e424f95ddfe86bbced91becfa0ab0a0418"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b43364e3519406a6d6c4c66255c369e424f95ddfe86bbced91becfa0ab0a0418"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b43364e3519406a6d6c4c66255c369e424f95ddfe86bbced91becfa0ab0a0418"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dc1f4ae207bd7fa1e34a234885e33120158b6dd58bb77f19c02c28d3c21b4f5"
    sha256 cellar: :any_skip_relocation, ventura:       "2dc1f4ae207bd7fa1e34a234885e33120158b6dd58bb77f19c02c28d3c21b4f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "463460a6d267dc1397b6f598fbe98c52ee50e406353b3e1644e8defca332bf9a"
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
