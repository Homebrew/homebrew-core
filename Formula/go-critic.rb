class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https://go-critic.com"
  url "https://github.com/go-critic/go-critic/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "8d69b35fc35dfc8adaf9b5d961e3c15405dbf8e13c40d1492097723a64245cc7"
  license "MIT"
  head "https://github.com/go-critic/go-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5206f5f42e58d7997e8f185d120c84b4120e3e74a40dacde8a51e8ac92e6db43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46a8fcf4fc017cd4c452980eb25b19f638885aa330709acfa507be54744fb0cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac7fe744a03ad47c2606e46bfd2ecf341d4f7348a622630feda47f5b95d28462"
    sha256 cellar: :any_skip_relocation, ventura:        "ddbfcacb240bb8212bc3d7ae65794d1c9bbc28fb3bc47c80d6b1e7bc37675fa6"
    sha256 cellar: :any_skip_relocation, monterey:       "3a88b8e86c45ef9b6e4ad3aef49cb3fd9246abfa7dc7df6183abf5a95e4c6824"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e101c91c8a509a89be4f4392304d2f91d3cd6b9c0cee5da0fb2d0ee4dfd8214"
    sha256 cellar: :any_skip_relocation, catalina:       "470b539b01aa70d4e1ba0a54325c2e1c30c935fda537dda83938b9e142eddfe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1bb31f7fcbd7772dbcdd66ec9ce4ce188e7ef9e689223ebd6ed959951f587f6"
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
