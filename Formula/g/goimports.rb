class Goimports < Formula
  desc "Go formatter that additionally inserts import statements"
  homepage "https://pkg.go.dev/golang.org/x/tools/cmd/goimports"
  url "https://github.com/golang/tools/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "22fd6c3146bf6cd38aa1b1a4f94ddf9e07ac5eb62f5db713ceb6d91df015cf4a"
  license "BSD-3-Clause"
  head "https://github.com/golang/tools.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca90dbef740605cc5db799f43995bed529e19657730aa46f0aa50be1494b04e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca90dbef740605cc5db799f43995bed529e19657730aa46f0aa50be1494b04e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca90dbef740605cc5db799f43995bed529e19657730aa46f0aa50be1494b04e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ddc7c3208f83f9a7c88320295943fd47015e4668b86992802eb8613507d7297"
    sha256 cellar: :any_skip_relocation, ventura:       "7ddc7c3208f83f9a7c88320295943fd47015e4668b86992802eb8613507d7297"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97da6f382d5e73c679f0988c511c9cc59873c2aa1fbba7e0f2772af25c0da54e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3131fb3f740d2279f2d8bc5c4f5731bd0b4efd0d091e70292f753d75ee88c04"
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
