class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/refs/tags/v2.29.0.tar.gz"
  sha256 "083422c2d64f311062e7fe36ff1bd22c98b029f0a4d69f3e81fd0a4724139092"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f1d71dc551276979e813aee3f3d5e23088c1c6fb834a240525313ed3a72b3c85"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "be25ab6fcd58473a9bc26a4f68a65bd228cfa1ec3a83b4fe38b95ff73acd0ee2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "be25ab6fcd58473a9bc26a4f68a65bd228cfa1ec3a83b4fe38b95ff73acd0ee2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "be25ab6fcd58473a9bc26a4f68a65bd228cfa1ec3a83b4fe38b95ff73acd0ee2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "062ff973e1d1506215dddf65d8333604d472446fd35c39a12c264b9b91f772e2"
    sha256 cellar: :any,                 x86_64_linux:      "e8fe3c5bebdd5739f6a3307150967f890e7f3a4d7cdbc0b3aead2f21ae2d7920"
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
