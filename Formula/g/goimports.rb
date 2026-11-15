class Goimports < Formula
  desc "Go formatter that additionally inserts import statements"
  homepage "https://pkg.go.dev/golang.org/x/tools/cmd/goimports"
  url "https://github.com/golang/tools/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "52846a0ad92cde47a8ed152c5f1908f81daa93114c8fa5c10a8f19352af1a1d9"
  license "BSD-3-Clause"
  head "https://github.com/golang/tools.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0ff5c8a5ebdb146921f01d9b444b55afd2a185eee5c5261852b37a584fc98278"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0ff5c8a5ebdb146921f01d9b444b55afd2a185eee5c5261852b37a584fc98278"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0ff5c8a5ebdb146921f01d9b444b55afd2a185eee5c5261852b37a584fc98278"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2b2ae7a576b1433bf142f23b2eb280b0751432e17a03f05acf0d2fc95b4840ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3e1d11fa45468f5c2d8f1ee6222ca4e56a75a56234165bb90e5c17955e10b881"
  end

  depends_on "go"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
