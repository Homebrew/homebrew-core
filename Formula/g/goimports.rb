class Goimports < Formula
  desc "Go formatter that additionally inserts import statements"
  homepage "https://pkg.go.dev/golang.org/x/tools/cmd/goimports"
  url "https://github.com/golang/tools/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "c74b3b140f7fe5d5482e5fea18fb543bf34a13c9370ade58e402e5e87e0e4cbf"
  license "BSD-3-Clause"
  head "https://github.com/golang/tools.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "26ebe948bad087dac2b6b866453062700ffd5a0da8836de420de504bccfc0de1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "26ebe948bad087dac2b6b866453062700ffd5a0da8836de420de504bccfc0de1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "26ebe948bad087dac2b6b866453062700ffd5a0da8836de420de504bccfc0de1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b65adde4337e5249cf32d2c488de72b2814c631a0c60b0b4bfc3f3fae52ff409"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c59c444a7b389886938482da82fa25fb5cd479147d6d11f4be8c74c700ce0819"
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
