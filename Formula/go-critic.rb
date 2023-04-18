class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https://go-critic.com"
  url "https://github.com/go-critic/go-critic/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "5851e0ff36b32f8cd61a3441030de62a390cf61ed9e33d31304aee0074804165"
  license "MIT"
  head "https://github.com/go-critic/go-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "672fd22fe8379a2711e2ae4d890cac6411b5806cefbc0ad6519e88b24186e693"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "672fd22fe8379a2711e2ae4d890cac6411b5806cefbc0ad6519e88b24186e693"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "672fd22fe8379a2711e2ae4d890cac6411b5806cefbc0ad6519e88b24186e693"
    sha256 cellar: :any_skip_relocation, ventura:        "c56c42080247fc69a75ba7609eca677ee5f4b4d79a395009f29ddda1aa670bae"
    sha256 cellar: :any_skip_relocation, monterey:       "c56c42080247fc69a75ba7609eca677ee5f4b4d79a395009f29ddda1aa670bae"
    sha256 cellar: :any_skip_relocation, big_sur:        "c56c42080247fc69a75ba7609eca677ee5f4b4d79a395009f29ddda1aa670bae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d85b152e16b02af5cf8df9b11b9755433baed0bb7599a1a4d51475b36ccb2f8c"
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
