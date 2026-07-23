class Goimports < Formula
  desc "Go formatter that additionally inserts import statements"
  homepage "https://pkg.go.dev/golang.org/x/tools/cmd/goimports"
  url "https://github.com/golang/tools/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "26829576e4bb8e3fee60d2da2fcfb5f5b6c4780154b76cf73a667cd33a664a3c"
  license "BSD-3-Clause"
  head "https://github.com/golang/tools.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfbb53980737d272fabbe98a292d5c3d7e97d7edbeb17af5fe68a7094d763095"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfbb53980737d272fabbe98a292d5c3d7e97d7edbeb17af5fe68a7094d763095"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfbb53980737d272fabbe98a292d5c3d7e97d7edbeb17af5fe68a7094d763095"
    sha256 cellar: :any_skip_relocation, sonoma:        "fccc0f8ede4f41848515978172f23c43e1e3250fb5cb630c19e6d453468159b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3f32c6c05669185142666538ce206407e2d1cf74a757f5a8e02404a73d22e12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41bae1e8ff24656dfbf84ae57821fcf32c940ed12021d33e2620ac02127fbd10"
  end

  depends_on "go"

  def install
    chdir "cmd/goimports" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
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
