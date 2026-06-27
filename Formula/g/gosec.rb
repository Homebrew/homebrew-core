class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/refs/tags/v2.27.1.tar.gz"
  sha256 "166addad13e5b0a7b9f2745c4606e8435e17216a7658e3a256dae4a23628ae07"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a54b50f5ac2edc9104f6b820ac01a93922c7e10ecfaad6d707926cacc05b54b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a54b50f5ac2edc9104f6b820ac01a93922c7e10ecfaad6d707926cacc05b54b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a54b50f5ac2edc9104f6b820ac01a93922c7e10ecfaad6d707926cacc05b54b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "f347f278e4cff4dfee09c0d7af0e6cc8ff6f00aebecbeec17d2cce5b2d43b541"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5b2ca42eb5132b2b3ec53087ce82b3b1a82582e475bcc1088482bda335edf9f"
    sha256 cellar: :any,                 x86_64_linux:  "4ca47bd577aad12ae37866df3f24b18722b2efc1c0a77ff18e23248c8afb05ad"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.GitTag= -X main.BuildDate=#{time.iso8601}"
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
