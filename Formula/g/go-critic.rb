class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https://go-critic.com"
  url "https://github.com/go-critic/go-critic/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "fe9f1ade9ee20a59ccbed1ae2cfdfcab66b5e95d1f62f6a3d0bc0dc02b3815bb"
  license "MIT"
  head "https://github.com/go-critic/go-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c579725139db5e4805635f53a3da3d256116f8dc690fd1a89e5c98a7b76cd179"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c579725139db5e4805635f53a3da3d256116f8dc690fd1a89e5c98a7b76cd179"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c579725139db5e4805635f53a3da3d256116f8dc690fd1a89e5c98a7b76cd179"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e8469386f33d9e7e4234a7d875fc532ce0800b565d7156e9617330bf92dc67d"
    sha256 cellar: :any_skip_relocation, ventura:        "1e8469386f33d9e7e4234a7d875fc532ce0800b565d7156e9617330bf92dc67d"
    sha256 cellar: :any_skip_relocation, monterey:       "1e8469386f33d9e7e4234a7d875fc532ce0800b565d7156e9617330bf92dc67d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cd23c3d0f1218db485dac56e926c3e7b7974cd5d1ff5c055660d0d2407d53a9"
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
