class Goimports < Formula
  desc "Go formatter that additionally inserts import statements"
  homepage "https://pkg.go.dev/golang.org/x/tools/cmd/goimports"
  url "https://github.com/golang/tools/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "df7f087706730d85ced76f5f2e3d1a51703de3beb305acc72d1170d405f5a21e"
  license "BSD-3-Clause"
  head "https://github.com/golang/tools.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86f5f48d0cdac1376a2ea4ed730c36c970910eee27965ab596530b48cf78a783"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86f5f48d0cdac1376a2ea4ed730c36c970910eee27965ab596530b48cf78a783"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86f5f48d0cdac1376a2ea4ed730c36c970910eee27965ab596530b48cf78a783"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f99566b870b10f7cbee3c22e6be6c59648fbf0f61305da1eec0cb3f4bd71c21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "403f06cfe5a8855c36d3fc9a5893338bdf04f3f0431c91a67b0c36998a0983a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05fa520b201aeb8f8d5e1ddbe0660377da9cf553ae56a29d21e68d17de2e9f2c"
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
