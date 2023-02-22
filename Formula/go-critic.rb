class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https://go-critic.com"
  url "https://github.com/go-critic/go-critic/archive/refs/tags/v0.6.7.tar.gz"
  sha256 "f97572991de7c4a3c2aec7b32c6b73dd3b423d964d33c3102b65b5086b47bca5"
  license "MIT"
  revision 1
  head "https://github.com/go-critic/go-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ed86998dcc7f9ee4a5498b4d531057c95e75b3fc78fd75528d2c356b99337dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09fc8e1453f3296d940bcfdd0fe26d648d44970d3dcc092ecb83e207e7f3de6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10b27174dcea10313b64bf66b3d473412adfa10e0adde2b412487798e5625366"
    sha256 cellar: :any_skip_relocation, ventura:        "1908e376891d7c4ff4eb509e5077f5793288835f490ffb014d3bc949ef21ef39"
    sha256 cellar: :any_skip_relocation, monterey:       "b935f443fe8fb95a0751627c1446713608137d1a08f6c71e0236586fd860b95f"
    sha256 cellar: :any_skip_relocation, big_sur:        "05dffb3b52689a8494edaec77c2b0fbd7d59bff432d1fdc87301f69faea728ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83c0a215555b42b9be3c0427c9a09ab1265232ecd6acba207e3bb46c410278c2"
  end

  depends_on "go"

  def install
    ldflags = "-s -w"
    ldflags += " -X main.Version=v#{version}" unless build.head?
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"gocritic"), "./cmd/gocritic"
  end

  test do
    (testpath/"main.go").write <<~EOS
      package main

      import "fmt"

      func main() {
        str := "Homebrew"
        if len(str) <= 0 {
          fmt.Println("If you're reading this, something is wrong.")
        }
      }
    EOS

    output = shell_output("#{bin}/gocritic check main.go 2>&1", 1)
    assert_match "sloppyLen: len(str) <= 0 can be len(str) == 0", output
  end
end
