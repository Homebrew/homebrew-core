class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https://go-critic.com"
  url "https://github.com/go-critic/go-critic/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "11d88b56179ecc08756a1330ba463e7bbeb9876399f0c6ba886eeff0d1e14e83"
  license "MIT"
  head "https://github.com/go-critic/go-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50c8c70c14a8e83675d4f1c4ffeefa2b644bfdb0cf839ce1e273edbd0750bb0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50c8c70c14a8e83675d4f1c4ffeefa2b644bfdb0cf839ce1e273edbd0750bb0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50c8c70c14a8e83675d4f1c4ffeefa2b644bfdb0cf839ce1e273edbd0750bb0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f763440903ea98e812aeff067e3f7a9eb75dc7dc0d762b80220d174b3d23cccf"
    sha256 cellar: :any_skip_relocation, ventura:       "f763440903ea98e812aeff067e3f7a9eb75dc7dc0d762b80220d174b3d23cccf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee684f9410062dc2606295cd446a34e6bded25d617f79ce362c1eb0ad180a3f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9a66287c2f86b2a23054780b98fda6100e8b03dfe8a08501a84835f95e2de01"
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
