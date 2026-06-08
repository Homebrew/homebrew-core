class Goimports < Formula
  desc "Go formatter that additionally inserts import statements"
  homepage "https://pkg.go.dev/golang.org/x/tools/cmd/goimports"
  url "https://github.com/golang/tools/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "1763e56760a51f25ddf1e73cc8ada35c3f81f2fa1094b6118acaa8ec5a51a146"
  license "BSD-3-Clause"
  head "https://github.com/golang/tools.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1f83890ad59a1de3b0a1ac17d410ee9359a1f7e898755a504b1c43ed549cbc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1f83890ad59a1de3b0a1ac17d410ee9359a1f7e898755a504b1c43ed549cbc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1f83890ad59a1de3b0a1ac17d410ee9359a1f7e898755a504b1c43ed549cbc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed237cb984242833274ca34dda9d1ceadb46b94b68a424e886cf7771d112594d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b7e383755c8d3ede4537feed35019dc4db791b67677541f7b8514250726e39d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f4983c9e9993c1ae954cfdeae2d44d5ad3c2dada8e1cee10d9f31e44e589325"
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
