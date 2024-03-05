class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "98ade316176d434f298bdb36e4c421e3c4c33668cfd2922d358f7f0403566500"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5167cb5986f5d9818ad230574072ea34c8fc4221bce401c90eb0236dd3ce62f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c677e7d91b35e1e087183a12b5c94d1601c59e13861385913b564c5d96ebdd5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21196d08acd7975e1f4eb4b9893942f576b1b59c16a18e5c17dc9d29f5458b1a"
    sha256 cellar: :any_skip_relocation, sonoma:         "7652b0fd742d195c844a367bf2f7ee9c8731469a60306fdc511a89c2efd24224"
    sha256 cellar: :any_skip_relocation, ventura:        "6951a65b83e415ac31baf30a04e4c7da7ba6b7a3a9566c6dcf355686f4ecf0ce"
    sha256 cellar: :any_skip_relocation, monterey:       "3e045cb31fce426d644f81f4c19e9f5623b23dee368a2b73a29007298cb8fa3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da8eeb880d156a43ac0b33f670a155a23caaeca7df79964b9c187fb92fe4977b"
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
