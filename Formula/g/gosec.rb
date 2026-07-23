class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/refs/tags/v2.28.0.tar.gz"
  sha256 "ccf7fa75b606c2adfcafadd6a3830966a161c4350a90fdfe4f15d6230da86d8f"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7d36f2587bced92f1d14c0fb21798ce455b65884c7711d8b1d7c884b011e882"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7d36f2587bced92f1d14c0fb21798ce455b65884c7711d8b1d7c884b011e882"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7d36f2587bced92f1d14c0fb21798ce455b65884c7711d8b1d7c884b011e882"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bbb7e27f4ab01dad78e7523d565170be1067232e89579ae3d73477ac8a185af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5226d50a149a1c03d221d279a92547e32ce8de15ae188aa47a71de1e18324e7f"
    sha256 cellar: :any,                 x86_64_linux:  "3f4678ae89f7fa2e2361cd4fb205d49d426d11fe1fb40af266deaa1b04ffb0e3"
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
