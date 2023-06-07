class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https://go-critic.com"
  url "https://github.com/go-critic/go-critic/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "537a63799bd90d903d2c79db2caf29f6b26807991e1ecb8d686d947860faf4b2"
  license "MIT"
  head "https://github.com/go-critic/go-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43ee2f016d9a3fa2da18ea46b4952948e61d232d3f258871c9134f97131a9e39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43ee2f016d9a3fa2da18ea46b4952948e61d232d3f258871c9134f97131a9e39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43ee2f016d9a3fa2da18ea46b4952948e61d232d3f258871c9134f97131a9e39"
    sha256 cellar: :any_skip_relocation, ventura:        "633a79266af1df625abccf81eedd6a808539aaadb5bf71754f0cd991efcf0a85"
    sha256 cellar: :any_skip_relocation, monterey:       "633a79266af1df625abccf81eedd6a808539aaadb5bf71754f0cd991efcf0a85"
    sha256 cellar: :any_skip_relocation, big_sur:        "633a79266af1df625abccf81eedd6a808539aaadb5bf71754f0cd991efcf0a85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01aec52aee1170f6fbc2c304d2302884314de73df121c3d7199beb6d80da5aaa"
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
