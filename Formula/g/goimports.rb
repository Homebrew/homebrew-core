class Goimports < Formula
  desc "Go formatter that additionally inserts import statements"
  homepage "https://pkg.go.dev/golang.org/x/tools/cmd/goimports"
  url "https://github.com/golang/tools/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "061210bf489d98197e029547dbf6e2e186aeb1c43ac472e5174ec05957d40195"
  license "BSD-3-Clause"
  head "https://github.com/golang/tools.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd27190e84a564681795c5f1a70d371b153cd935518d0355d4ef772da7c0f271"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd27190e84a564681795c5f1a70d371b153cd935518d0355d4ef772da7c0f271"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd27190e84a564681795c5f1a70d371b153cd935518d0355d4ef772da7c0f271"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d8e507e209614eaef8f45101e31f5fc15ee14df22580f21bbcc432d443a2f3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c18c26d7da534dd4f330a0bb81310ef8b13774427fabf8ddec8367aa11cea637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15501663d896b38c3e9cc07abfcfca951e35475450c65bd49d38fcf98a978b0f"
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
