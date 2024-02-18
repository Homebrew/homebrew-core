class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https://go-critic.com"
  url "https://github.com/go-critic/go-critic/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "d68d3780d7111953b2ed8e7078aaa2241d91c1e88f9c665e32f1aa78d92297bd"
  license "MIT"
  head "https://github.com/go-critic/go-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db4df8a2cd0ebaf4f62bc19683054d1bf3a34ba83296744713ada640dd11e5d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db4df8a2cd0ebaf4f62bc19683054d1bf3a34ba83296744713ada640dd11e5d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db4df8a2cd0ebaf4f62bc19683054d1bf3a34ba83296744713ada640dd11e5d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "851d2e5aaf31e7e4be7adf89510bdd7c4b112c0d68f3817f9cbe31022f4ef3e8"
    sha256 cellar: :any_skip_relocation, ventura:        "851d2e5aaf31e7e4be7adf89510bdd7c4b112c0d68f3817f9cbe31022f4ef3e8"
    sha256 cellar: :any_skip_relocation, monterey:       "851d2e5aaf31e7e4be7adf89510bdd7c4b112c0d68f3817f9cbe31022f4ef3e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5fd963a0e7088a93fc237cba7afd5802e7e865584bd20afa3a9c8afdf5de073"
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
