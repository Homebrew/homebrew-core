class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/refs/tags/v2.22.2.tar.gz"
  sha256 "790a473a4d8b4d6181268e7eb9481296ecef040007185f4924cdf864d9badccb"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7443b74f73d3ea93e4798dcb4167f95c007619849ff136ae0debd7ac1e02abab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7443b74f73d3ea93e4798dcb4167f95c007619849ff136ae0debd7ac1e02abab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7443b74f73d3ea93e4798dcb4167f95c007619849ff136ae0debd7ac1e02abab"
    sha256 cellar: :any_skip_relocation, sonoma:        "20398d7cbfa0f9dd0c117e8d05856a805f4c66545f981ddd25756f26b82aff6f"
    sha256 cellar: :any_skip_relocation, ventura:       "20398d7cbfa0f9dd0c117e8d05856a805f4c66545f981ddd25756f26b82aff6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2384c4a3cc08a05035afb417802d4b28d859240085409a42a4057b8870806475"
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
