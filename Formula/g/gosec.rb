class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/refs/tags/v2.30.0.tar.gz"
  sha256 "58ad3a584453ad31f0b646818bcd1cc005afd20ef507d71cd41821fbba506332"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7dba80f404f85b06207eadbbd40fb2ba5089f636e7ace683e7a4305460069d6d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7dba80f404f85b06207eadbbd40fb2ba5089f636e7ace683e7a4305460069d6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7dba80f404f85b06207eadbbd40fb2ba5089f636e7ace683e7a4305460069d6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "48f3ecb3d9acfe73ac5f2f41548b86018f3d577b4da686aaff38ed43d5fbe5ac"
    sha256 cellar: :any,                 x86_64_linux:      "6c098daff552aad6febd17a03158aa1bfcb27179a044c7150463f0716bfecbec"
  end

  depends_on "go"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.Version=#{version} -X main.GitTag= -X main.BuildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gosec"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gosec --version")

    (testpath/"test.go").write <<~GO
      package main

      import "fmt"

      func main() {
          username := "admin"
          var password = "f62e5bcda4fae4f82370da0c6f20697b8f8447ef"

          fmt.Println("Doing something with: ", username, password)
      }
    GO

    output = shell_output("#{bin}/gosec ./...", 1)
    assert_match "G101 (CWE-798)", output
    assert_match "Issues : \e[1;31m1\e[0m", output
  end
end
