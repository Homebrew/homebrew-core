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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3197404b7b05308a986a48b98e12785b6d49ad1f85e1a5de0ad070bf41aa2d1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da0270e777fd23cd55c5e6814926867f3892dbd5a5a491aaca344a4ae31cc83e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf5548b7ab762118765f9a6dd9ce8c01ced430148dea609a281ed50765bc58f5"
    sha256 cellar: :any_skip_relocation, ventura:        "5db5970878192f8fe8dd96ff415e9f043c424b162926e7bd24341e26199b0e72"
    sha256 cellar: :any_skip_relocation, monterey:       "0340b0739e7447923e715ab9e7a98ac31f6b91969115e9cfb5b0e1cd6315c613"
    sha256 cellar: :any_skip_relocation, big_sur:        "def93341bf1ecb58d093d58faa6083ea1eb4e35017bb2ed3bc2e3a3b310625f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fc75d4e6599049e932d8e0b7ae0516b3ca2906f96297a05ed6f4a6a7f1c9a76"
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
