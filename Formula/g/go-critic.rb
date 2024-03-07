class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https://go-critic.com"
  url "https://github.com/go-critic/go-critic/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "fefe17a18ef01928ea8611999e9eee648003230be43155f9f0b4b34383c77815"
  license "MIT"
  head "https://github.com/go-critic/go-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06a4a406018abb0cffba1ddb97ce6f1e69c21e25c878e9ea080f9155822eada7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06a4a406018abb0cffba1ddb97ce6f1e69c21e25c878e9ea080f9155822eada7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06a4a406018abb0cffba1ddb97ce6f1e69c21e25c878e9ea080f9155822eada7"
    sha256 cellar: :any_skip_relocation, sonoma:         "40b3da468966ad7e2d0257be75805779b19743ba612cf717a7cfc3e2133662ee"
    sha256 cellar: :any_skip_relocation, ventura:        "40b3da468966ad7e2d0257be75805779b19743ba612cf717a7cfc3e2133662ee"
    sha256 cellar: :any_skip_relocation, monterey:       "40b3da468966ad7e2d0257be75805779b19743ba612cf717a7cfc3e2133662ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cace4efd094f505b5b6ceeaef38f4bbe5a304bf2681dd94d05bfd98d4c33f49d"
  end

  depends_on "go"

  def install
    ldflags = "-s -w"
    ldflags += " -X main.Version=v#{version}" unless build.head?
    system "go", "build", *std_go_args(ldflags:, output: bin/"gocritic"), "./cmd/gocritic"
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
