class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "98ade316176d434f298bdb36e4c421e3c4c33668cfd2922d358f7f0403566500"
  license "BSD-3-Clause"
  revision 4
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e394ccd2be6c3b1d1f731d1ff1be0b7046b45feb1859c9e4a96379716ac2b11"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45330a4ba4325addf692c275ea557949aadf61b29998ab9eaed244105dc7450f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90d4954ae32ca4f8f1a571124350b1f592b608d68bf34a541964670e44b59735"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e6ed3cd23ae631eee39ad5144b178e160af60d9768c68de42c368012e15104c"
    sha256 cellar: :any_skip_relocation, ventura:        "4b32121194626e8786716e0aa112f71666c48f7358f51d42a996e7cb1ef0b65f"
    sha256 cellar: :any_skip_relocation, monterey:       "b222a8a90195fc325b517d67c4b2aba962b7cd6eb4528b4e666251dba817dc6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be4a5c8a7e3c37ad11850c849c6d662ad519b805548212697bb409c3b5ee97ed"
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
