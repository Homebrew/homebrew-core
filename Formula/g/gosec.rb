class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/refs/tags/v2.22.9.tar.gz"
  sha256 "27d53b5a87343b35370597a0395c72e7c81944843bf53dec6e2dd9eb990073c5"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "672bcc7c585a8f9d4bf7642d5af9e593579b2f8b03d05240f516cdf4d3fc9479"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "672bcc7c585a8f9d4bf7642d5af9e593579b2f8b03d05240f516cdf4d3fc9479"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "672bcc7c585a8f9d4bf7642d5af9e593579b2f8b03d05240f516cdf4d3fc9479"
    sha256 cellar: :any_skip_relocation, sonoma:        "c06222e721920f0404c6d2fa1fe821e5f0847eda3de181b93f7f7d482ad78cbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ae421c1be41f28fdd317d8ea406f44c63c4dadfa5244574e105816423199eec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc08c5296d2346d4b55a588e6bb24cb13ff0adbcc97f5439a36746ac6e69d611"
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
