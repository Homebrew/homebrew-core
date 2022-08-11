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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f58f12f36c5a1712de6db574598a80105c75fee96232d856c9b6ec0ad430d0b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2300ce205e6355a4b49fcdcbc96c630061915f79671928cb6a255129fbe790c"
    sha256 cellar: :any_skip_relocation, monterey:       "8a0e97bd399a51910a9fc521393dd4503b55804fc43dcbeff78c5e6b68de8b02"
    sha256 cellar: :any_skip_relocation, big_sur:        "b62070bbd343a72289f5691667129b75c5aff68d615e8e73701521fb7a027734"
    sha256 cellar: :any_skip_relocation, catalina:       "b9ed78da1fddff6d8ba0b8233f4cc63ae7077dafbfe6d57a9e8c0c5b123ec40c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a02266c34317c1b76bb1735cc4932b59465c05531642d39328a429dcbf72c10"
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
