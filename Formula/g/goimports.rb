class Goimports < Formula
  desc "Go formatter that additionally inserts import statements"
  homepage "https://pkg.go.dev/golang.org/x/tools/cmd/goimports"
  url "https://github.com/golang/tools/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "2df1ea5f56bb095c396b3a2d65252db15321165e785b7e5d9f5d78230e1cc68f"
  license "BSD-3-Clause"
  head "https://github.com/golang/tools.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3978e64b68ec03e4f65d04ad9965e9aa7bf1c4b87eaf91f9d0c2cfcde7a406ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3978e64b68ec03e4f65d04ad9965e9aa7bf1c4b87eaf91f9d0c2cfcde7a406ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3978e64b68ec03e4f65d04ad9965e9aa7bf1c4b87eaf91f9d0c2cfcde7a406ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "d09f9011cf9c4d36ebd2932485b614e3a35ab2b42fdec19a8bdb365922bbce26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4669e4f3d0a7e19cd4a906a2896758fa8f7a6f1dfc8a3070b6be6972a5d7c051"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9aecfb489dc31cafa6c00ad97c63dafad79029150d9cf3e866232a3401476c46"
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
