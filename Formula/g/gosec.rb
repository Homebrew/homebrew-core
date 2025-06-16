class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/refs/tags/v2.22.5.tar.gz"
  sha256 "a0cfe91b35e36c46214f1a761a149d938a9c2bcf8be3b14be335f53cc24cc1cd"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da158987cfb96c51a3a6d417fdd5357f663d6166ead330e4bf479086076db925"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da158987cfb96c51a3a6d417fdd5357f663d6166ead330e4bf479086076db925"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da158987cfb96c51a3a6d417fdd5357f663d6166ead330e4bf479086076db925"
    sha256 cellar: :any_skip_relocation, sonoma:        "225f37120160af2ba727c827044c5c2a09531bb37c52b112fe1093e356831637"
    sha256 cellar: :any_skip_relocation, ventura:       "225f37120160af2ba727c827044c5c2a09531bb37c52b112fe1093e356831637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bd30d4d1b574d5553f458dd940dd1ff2bef2f4486638af5b2d3fd1850be4e1f"
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
