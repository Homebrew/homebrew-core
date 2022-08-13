class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https://go-critic.com"
  url "https://github.com/go-critic/go-critic/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "5116902a2972ed8c729eb982bf512c84203e2afe40a45bfb3f0fb682cc02ed64"
  license "MIT"
  head "https://github.com/go-critic/go-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45e767285d0a9ef074588503f5f0df9436a5e249a996f344823f37de0b791081"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "865f8482139ec2583e0d3d6e28d4c86cca00dc5d1b5b0c9a1400773624e0b05d"
    sha256 cellar: :any_skip_relocation, monterey:       "6e866c19a692a8b2d9d5eda2135acfd0166ddef4ecc35e7db49c727daa71cb1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbee92db712e502ec417857befd4ad9ac2d66fe92095dab87acb700d7cf2931c"
    sha256 cellar: :any_skip_relocation, catalina:       "26959062f1aba68b61b9dd1139b559d61c6bb5a13a28df20fbd0b71ae337f2e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b38fb5d4b775c7376c48e92be3f856d6a44b78860f7c43db46e6928274fd65fd"
  end

  depends_on "go"

  def install
    ldflags = "-s -w"
    ldflags += " -X main.Version=v#{version}" unless build.head?
    system "go", "build", "-trimpath", "-ldflags", ldflags, "-o", bin/"gocritic", "./cmd/gocritic"
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
