class Goimports < Formula
  desc "Go formatter that additionally inserts import statements"
  homepage "https://pkg.go.dev/golang.org/x/tools/cmd/goimports"
  url "https://github.com/golang/tools/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "6a88c95ce260c45fe9bdf49a3286db72e4fd3732a873676d551b777407345acf"
  license "BSD-3-Clause"
  head "https://github.com/golang/tools.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b45ecb2d58281f3d0500728dd296ed6b9992c15ca210208a137823b00eea7c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b45ecb2d58281f3d0500728dd296ed6b9992c15ca210208a137823b00eea7c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b45ecb2d58281f3d0500728dd296ed6b9992c15ca210208a137823b00eea7c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b45ecb2d58281f3d0500728dd296ed6b9992c15ca210208a137823b00eea7c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ccf6b170ef6c55bf76da356b60f393cf4cde52112f22c0b2e44cee62bd7bfc3"
    sha256 cellar: :any_skip_relocation, ventura:       "3ccf6b170ef6c55bf76da356b60f393cf4cde52112f22c0b2e44cee62bd7bfc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "908f0952726376a899dd711baff91467cc1d4742c0142dda6237773765c7f66e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b550f54bdab323d8f7fd094d44e2fb0bd08d752060905047ca1d10e57e2175cd"
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
