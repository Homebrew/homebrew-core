class Gotestsum < Formula
  desc "Human friendly `go test` runner"
  homepage "https://github.com/gotestyourself/gotestsum"
  url "https://github.com/gotestyourself/gotestsum/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "8a7c1fd85cf3b5399b4ce59454d1f10fbd6b82e55e63ff8390446cec9af9f43f"
  license "Apache-2.0"
  head "https://github.com/gotestyourself/gotestsum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ba88a9fe11f727dc1b1deb0ede5560b5a2f890bd96d958cc4e8695b5136a7bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ba88a9fe11f727dc1b1deb0ede5560b5a2f890bd96d958cc4e8695b5136a7bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ba88a9fe11f727dc1b1deb0ede5560b5a2f890bd96d958cc4e8695b5136a7bb"
    sha256 cellar: :any_skip_relocation, ventura:        "2f02417a800232286041d084e57828cc83528117eaf9cf66a84c70f2822118ce"
    sha256 cellar: :any_skip_relocation, monterey:       "2f02417a800232286041d084e57828cc83528117eaf9cf66a84c70f2822118ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f02417a800232286041d084e57828cc83528117eaf9cf66a84c70f2822118ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5928456f4fc58720906fc771133a4ea43fdeb13b6a105f7a17ef61d90f493ede"
  end

  depends_on "go" => [:build, :test]

  def install
    ldflags = "-s -w -X gotest.tools/gotestsum/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    (testpath/"go.mod").write <<~EOS
      module github.com/Homebrew/brew-test

      go 1.18
    EOS

    (testpath/"main.go").write <<~EOS
      package main

      import "fmt"

      func Hello() string {
        return "Hello, gotestsum."
      }

      func main() {
        fmt.Println(Hello())
      }
    EOS

    (testpath/"main_test.go").write <<~EOS
      package main

      import "testing"

      func TestHello(t *testing.T) {
        got := Hello()
        want := "Hello, gotestsum."
        if got != want {
          t.Errorf("got %q, want %q", got, want)
        }
      }
    EOS

    output = shell_output("#{bin}/gotestsum --format=testname")
    assert_match "DONE 1 tests", output

    assert_match version.to_s, shell_output("#{bin}/gotestsum --version")
  end
end
