class Goimports < Formula
  desc "Go formatter that additionally inserts import statements"
  homepage "https://pkg.go.dev/golang.org/x/tools/cmd/goimports"
  url "https://github.com/golang/tools/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "f058eb3f9d53c2c0315f0de0b6a86391e41e4249a35faf0703d77a5e7c286173"
  license "BSD-3-Clause"
  head "https://github.com/golang/tools.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54da2b1b42fb358f08d943046c6e1cdcbac37a537cbc8b963d572e3f1d594ea7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54da2b1b42fb358f08d943046c6e1cdcbac37a537cbc8b963d572e3f1d594ea7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54da2b1b42fb358f08d943046c6e1cdcbac37a537cbc8b963d572e3f1d594ea7"
    sha256 cellar: :any_skip_relocation, sonoma:        "695818c0b36649b9dd7b3928198d54a90ccbc690776c9367f8ecb843825fa2e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36de8cfb52c609ddc656151c335e6a7dfc443992feca070d0bd829aa2165e4da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e9f54ccda90a6e63dcdd3a9689ba172b7b9eeefd911c2289c384a95c287269a"
  end

  depends_on "go"

  def install
    chdir "cmd/goimports" do
      system "go", "build", *std_go_args
    end
  end

  test do
    (testpath/"main.go").write <<~GO
      package main

      func main() {
        fmt.Println("hello")
      }
    GO

    assert_match(/\+import "fmt"/, shell_output("#{bin}/goimports -d #{testpath}/main.go"))
  end
end
