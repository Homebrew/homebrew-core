class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https://go-critic.com"
  url "https://github.com/go-critic/go-critic/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "d2e266aa6f7e7390a12144c159f616a7eaa2c37a4834a169b2debd33e601467a"
  license "MIT"
  revision 1
  head "https://github.com/go-critic/go-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9a212a31f7d17a2d38edd8ca1ff8858bea92ad04b616a29a348e4bc4e987561"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9a212a31f7d17a2d38edd8ca1ff8858bea92ad04b616a29a348e4bc4e987561"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9a212a31f7d17a2d38edd8ca1ff8858bea92ad04b616a29a348e4bc4e987561"
    sha256 cellar: :any_skip_relocation, ventura:        "fc82502653f1ecedf666130b3844d6345537a228c23492a041e35bd369d30da3"
    sha256 cellar: :any_skip_relocation, monterey:       "fc82502653f1ecedf666130b3844d6345537a228c23492a041e35bd369d30da3"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc82502653f1ecedf666130b3844d6345537a228c23492a041e35bd369d30da3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1107319e79944ee3051601f1085a48f4807de7194d3f3a504243bab83ab70a4"
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
