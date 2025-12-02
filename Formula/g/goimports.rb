class Goimports < Formula
  desc "Go formatter that additionally inserts import statements"
  homepage "https://pkg.go.dev/golang.org/x/tools/cmd/goimports"
  url "https://github.com/golang/tools/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "8dcc9173990f36a91166e6744741ec6d6c893c5529bd52fe46ba910a3471c837"
  license "BSD-3-Clause"
  head "https://github.com/golang/tools.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1faaad374c3cf76b1969bdadc311e978b2f1f45ec00b28d8d6bfd1c1dcf5cde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1faaad374c3cf76b1969bdadc311e978b2f1f45ec00b28d8d6bfd1c1dcf5cde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1faaad374c3cf76b1969bdadc311e978b2f1f45ec00b28d8d6bfd1c1dcf5cde"
    sha256 cellar: :any_skip_relocation, sonoma:        "77b64b9e46a45b80b68e823281d288bb6013ea45e5b1c1b8930438292f12db51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfdcda1d3699bb3f41c1cb0215f689285f27e8ccfb11da7427164610ac640a80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba7be44ee67a0a45b566bfcb6e413f6c7141d385f7e592eef29feac5a7dd9ee3"
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
