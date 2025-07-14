class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "aea6e0a172296b50e3671a9b753aeb2eb7080a3103575cdf5e4d1aeccfe14ede"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09dfd46a9b72ad64bb2f89547a75613c5e6c53213f44f933cd77d85e1d1e53ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09dfd46a9b72ad64bb2f89547a75613c5e6c53213f44f933cd77d85e1d1e53ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09dfd46a9b72ad64bb2f89547a75613c5e6c53213f44f933cd77d85e1d1e53ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "8187285498221c374f65a4983b5d9ecc0599c45454bec7a5aea103b157d8eb15"
    sha256 cellar: :any_skip_relocation, ventura:       "8187285498221c374f65a4983b5d9ecc0599c45454bec7a5aea103b157d8eb15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8f28b8e37cef16d86fca4b5a46190112e7d95718102b9ba764d25e71608d3bf"
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
