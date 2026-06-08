class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https://go-critic.com"
  url "https://github.com/go-critic/go-critic/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "baf54665063087dc48d2261822229a3d8ab670fcec38fc5e25cd6350732746cb"
  license "MIT"
  head "https://github.com/go-critic/go-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36f3b8b5a46c5c69662d86c2ce02536aa8cd0852096f1292f732626b4a147e70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36f3b8b5a46c5c69662d86c2ce02536aa8cd0852096f1292f732626b4a147e70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36f3b8b5a46c5c69662d86c2ce02536aa8cd0852096f1292f732626b4a147e70"
    sha256 cellar: :any_skip_relocation, sonoma:        "a362645959022e39c2b229e6159b79dc5b30f218d8fbe58fa53d69ecf3117d76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0dd5e70661ab061df20bde3752473eddbc9f45e5f33a1cfcbe6e50d9d688d61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69d045cfbb182d91c41e6f11210579be1013377ad00ffb63aea243be86c1dc61"
  end

  depends_on "go"

  def install
    ldflags = "-s -w"
    ldflags += " -X main.Version=v#{version}" if build.stable?
    system "go", "build", *std_go_args(ldflags:, output: bin/"gocritic"), "./cmd/gocritic"
  end

  test do
    (testpath/"main.go").write <<~GO
      package main

      import "fmt"

      func main() {
        str := "Homebrew"
        if len(str) <= 0 {
          fmt.Println("If you're reading this, something is wrong.")
        }
      }
    GO

    output = shell_output("#{bin}/gocritic check main.go 2>&1", 1)
    assert_match "sloppyLen: len(str) <= 0 can be len(str) == 0", output
  end
end
