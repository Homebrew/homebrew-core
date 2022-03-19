class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https://go-critic.com"
  url "https://github.com/go-critic/go-critic/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "75248d8a909e8655040b3af778d92b27beca271dcc210e546607abecc9589d09"
  license "MIT"
  revision 1
  head "https://github.com/go-critic/go-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "964d24f8981cf9f19ed6a178d20c90071b4552c7ed4f86e564ab13a2e48655dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e409e5c08f008b7ba322c59aac43306cba3cc18290e4eaa75745791b9a7f2622"
    sha256 cellar: :any_skip_relocation, monterey:       "896e324a2277836590b20b7522d24f3f636fba23cf83a3d3e821e2c9e5876d67"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1a8f310e0ad8f7c9cff6eea0e0330b90fb2798364389d2c812f16062735219e"
    sha256 cellar: :any_skip_relocation, catalina:       "f7d4f1594485b52fc197a08792423446c3a368695a1b9ed6411f85fa6c86abaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "110174e2f99878edbc312d8d3bbc117b4e15b66b83b69774c94f4d7baa56b2be"
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
