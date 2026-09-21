class Goimports < Formula
  desc "Go formatter that additionally inserts import statements"
  homepage "https://pkg.go.dev/golang.org/x/tools/cmd/goimports"
  url "https://github.com/golang/tools/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "22d397e6b0a3040aae4fbc6fccb7738b31575a86b754b8604892353f195368a2"
  license "BSD-3-Clause"
  head "https://github.com/golang/tools.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "31425572d724f31ad831a6b38968087d0e6fa77b98baf3bf1ab7d16cd3e1a8dc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "31425572d724f31ad831a6b38968087d0e6fa77b98baf3bf1ab7d16cd3e1a8dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "31425572d724f31ad831a6b38968087d0e6fa77b98baf3bf1ab7d16cd3e1a8dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "31425572d724f31ad831a6b38968087d0e6fa77b98baf3bf1ab7d16cd3e1a8dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d37c612b3995b69b87d8a95295872b631c657cb88f8386d1fc62ac439419d25e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9e7bd3bc6361e6106bec622e95c57d726e330239124b14909228a58aec5a3e39"
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
