class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https://go-critic.com"
  url "https://github.com/go-critic/go-critic/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "6b5d2543c76700865de5d4cef17004cc1c33c437cccd04718cf40411a4cf6d83"
  license "MIT"
  head "https://github.com/go-critic/go-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a77ac84e936fdb767303dfa002b05c7092ad0257751156dde0743050ef7023d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d24bb21bc493d5662920c6a2453ae306ecce5390c41ce7b1ac329fd3294dd1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3f2d04eebe15c8a4f8cd94619c45a48f16ea7f413793bd461a61756b11b84b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ad340044411d6b2f4d5a6201c99c5f48d8cb595efcfd9b99bda2ddeb6e5fffe"
    sha256 cellar: :any_skip_relocation, ventura:        "99ec7ce91c870c7c0fee8657cc5ea59a16d8e54c10aa451c49d90ea5c523b425"
    sha256 cellar: :any_skip_relocation, monterey:       "83c43daed295f313406812cd0ef53145c915626e435d7be41ac8d4edd9c384e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45df76f9c365d8398b3ababa7f918d767e75fc2a201de9703fc94d85b5e3efb2"
  end

  depends_on "go"

  def install
    ldflags = "-s -w"
    ldflags += " -X main.Version=v#{version}" unless build.head?
    system "go", "build", *std_go_args(ldflags:, output: bin/"gocritic"), "./cmd/gocritic"
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
