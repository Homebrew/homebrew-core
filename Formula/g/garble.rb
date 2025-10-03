class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "b429b24dafa851a25bbeca635db33eb4162b8e3109fb234a2c8e7780a837b958"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2cea3e26879537701838d2a9dabce5cc793bc9ac4a6e793e27720612df3b304"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2cea3e26879537701838d2a9dabce5cc793bc9ac4a6e793e27720612df3b304"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2cea3e26879537701838d2a9dabce5cc793bc9ac4a6e793e27720612df3b304"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2cea3e26879537701838d2a9dabce5cc793bc9ac4a6e793e27720612df3b304"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c67079b98f17e7b0fba76ca1034d6937ef2053ed5a6a683a2eb09ecb62101db"
    sha256 cellar: :any_skip_relocation, ventura:       "5c67079b98f17e7b0fba76ca1034d6937ef2053ed5a6a683a2eb09ecb62101db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f4f1598d9c2769351a128b107c22de29466aa968e841caa29320a807c425d03"
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
