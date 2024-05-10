class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "98ade316176d434f298bdb36e4c421e3c4c33668cfd2922d358f7f0403566500"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7baca4ab4c5ff53e9391d6f6611f21467e0f19708edf164a9595d74c298ca76d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "274646ba05fa7dd1ce066307e2952ab4ccf7a88b5bad55195de474a45295c227"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbe97eafde686782dbec49ba626e4b0859f962de6d5b08d6039e5a6aa872d3be"
    sha256 cellar: :any_skip_relocation, sonoma:         "645057a4cbc054fe72164979fd685ea17b3d4374a36105e6ab22a2a9153241f5"
    sha256 cellar: :any_skip_relocation, ventura:        "e9f71f4eca0bae55306c35f9508cca8c6177a7084fd68ec2022cca8d02e1e35b"
    sha256 cellar: :any_skip_relocation, monterey:       "14220fb44440486dbd176486897723eb7249f080fdd39119d6690e0503e23ccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb2610b4822c8f4cd7586a3a8eb513ce9db36d5bdff97af3b5816bac6344c1b8"
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
