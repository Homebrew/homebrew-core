class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/refs/tags/v2.22.11.tar.gz"
  sha256 "849420b5e2017a6fc1520c4034c740e24d03dede1724f2d3c78648e04732a35f"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "326b23495de19abbb74f43ee60f8103ee0406f2aa59a409a3a9caf3f2772612e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "326b23495de19abbb74f43ee60f8103ee0406f2aa59a409a3a9caf3f2772612e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "326b23495de19abbb74f43ee60f8103ee0406f2aa59a409a3a9caf3f2772612e"
    sha256 cellar: :any_skip_relocation, sonoma:        "98ad4fdb09c84b32deef0aac0eb4964f9868b86129ea91b60cf0ce3a68e8a8e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a3f1a7f543aef518a1c2d5ca0216357e970abb9f2a6ccaef16c26b848106fb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5791bbdae377cc07e9dbb916db567fa4030d9a54e1367c59b8258381176e8686"
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
