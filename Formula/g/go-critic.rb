class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https://go-critic.com"
  url "https://github.com/go-critic/go-critic/archive/refs/tags/v0.11.5.tar.gz"
  sha256 "df5771670f222759300edc2199dfd46090a876e7ecf5ac230984059cef0b0b83"
  license "MIT"
  head "https://github.com/go-critic/go-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b813049e20570cd0574c868ede6d8fde0ef5bd4384cdac881327d5f61ba1cd43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b813049e20570cd0574c868ede6d8fde0ef5bd4384cdac881327d5f61ba1cd43"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b813049e20570cd0574c868ede6d8fde0ef5bd4384cdac881327d5f61ba1cd43"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9498a478613227e62615b0c3d66f57fc6e97a526cf1d77d8da6f7a8e5076b04"
    sha256 cellar: :any_skip_relocation, ventura:       "f9498a478613227e62615b0c3d66f57fc6e97a526cf1d77d8da6f7a8e5076b04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3efaa09f0c7c9cba4db3cce6a5b2fb12ac347374456f988d2ef18520c0cb7aa0"
  end

  depends_on "go"

  def install
    ldflags = "-s -w"
    ldflags += " -X main.Version=v#{version}" unless build.head?
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
