class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "0eb231e6ad91793f0fcf086fb57a1654f0c2056284a79fb12ac955ade6791737"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96edd517d1314d5ab580260690fe54d90d4326835ddb29b9568a986f9f12f2d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96edd517d1314d5ab580260690fe54d90d4326835ddb29b9568a986f9f12f2d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "96edd517d1314d5ab580260690fe54d90d4326835ddb29b9568a986f9f12f2d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f14b8a0dba2b8c03c58ad53d15a7187c87d69302ce1b9d1bae29f0793d4adc1"
    sha256 cellar: :any_skip_relocation, ventura:       "5f14b8a0dba2b8c03c58ad53d15a7187c87d69302ce1b9d1bae29f0793d4adc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d75b356000cbfbb4c8b0a15a2f2ac9c354706aecf95b6cd41dd8fc76b25c4f9f"
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
