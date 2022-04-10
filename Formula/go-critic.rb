class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https://go-critic.com"
  url "https://github.com/go-critic/go-critic/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "74fd0995f401c49206b569f4c11be867da01f627e8979861d67ac8ea60173d7d"
  license "MIT"
  head "https://github.com/go-critic/go-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30a90e624d9157b4efce676c8f1536547e1d26abbf3f5db9084cc11762888d6a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d414b716729c9c1a273821abfe5b57c201d6d50b27780ccf8bddf8d77d4ed0fa"
    sha256 cellar: :any_skip_relocation, monterey:       "294208f2fdae2246b497a7658c075f4c58c6cb4a4b2f4860580da3879c60c1fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "554e375fbb293c29dcb9fab679566c69edcd0d809d43636f36a695a04538dfdf"
    sha256 cellar: :any_skip_relocation, catalina:       "88ed836b4e319630703cb510f87b42ab26eb088b9d211d4487f55fd8d7774cce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "336f19e78a3465a08715ecef05cebf7acee8ed02d5d12c9b1cfacbeacb2b69d7"
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
