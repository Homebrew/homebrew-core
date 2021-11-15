class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https://go-critic.com"
  url "https://github.com/go-critic/go-critic/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "5d20e626a2803317abb80a8705f80b3ee107f75fd097ca8efaff73173409dd52"
  license "MIT"
  head "https://github.com/go-critic/go-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b82d5036c29c85fcfc737f836b5f558227ed79792bd3f8bffd651f3df72ab73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28c94b91145a1f56d8af958f1990f3b3da574a04be295b91bb6e4d9e0f18dce6"
    sha256 cellar: :any_skip_relocation, monterey:       "9cebd489e58c7eb61943daa1626010ed93e62239325ad90d49c0c8c071184333"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ba3bc01bb35dc4c87f9f06fa26066cb6065d2a3bd1dbaec5d46a29b71ce4b7e"
    sha256 cellar: :any_skip_relocation, catalina:       "edded4a1c57798d6b34187e40f4099a8b0118495d9237f91d0f3612430c88461"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a239aabbb065dd06ed267c954277e8c2435b989366045fe29168600d5fe574b"
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
