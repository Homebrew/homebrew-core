class Gotestsum < Formula
  desc "Human friendly `go test` runner"
  homepage "https://github.com/gotestyourself/gotestsum"
  url "https://github.com/gotestyourself/gotestsum/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "b54036d05128be9e285f5eede74e1070a0267dead3d4e4065f492b7ea39a2353"
  license "Apache-2.0"
  head "https://github.com/gotestyourself/gotestsum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8b98801b467e6d6a9b1eeeae41eee2abba57d727a4aa2c80ac02067715a5979"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8b98801b467e6d6a9b1eeeae41eee2abba57d727a4aa2c80ac02067715a5979"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c8b98801b467e6d6a9b1eeeae41eee2abba57d727a4aa2c80ac02067715a5979"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0abdce26ad91243473e6be948adfe8b7fdf924a7c39fa79dd63fdca4d36f7dc"
    sha256 cellar: :any_skip_relocation, ventura:       "b0abdce26ad91243473e6be948adfe8b7fdf924a7c39fa79dd63fdca4d36f7dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb0af3a5b3c0a9bdd33d9495851bedcc4faaa185721a41534154244a10fa9986"
  end

  depends_on "go" => [:build, :test]

  def install
    ldflags = "-s -w -X gotest.tools/gotestsum/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath/"go.mod").write <<~GOMOD
      module github.com/Homebrew/brew-test

      go 1.18
    GOMOD

    (testpath/"main.go").write <<~GO
      package main

      import "fmt"

      func Hello() string {
        return "Hello, gotestsum."
      }

      func main() {
        fmt.Println(Hello())
      }
    GO

    (testpath/"main_test.go").write <<~GO
      package main

      import "testing"

      func TestHello(t *testing.T) {
        got := Hello()
        want := "Hello, gotestsum."
        if got != want {
          t.Errorf("got %q, want %q", got, want)
        }
      }
    GO

    output = shell_output("#{bin}/gotestsum --format=testname")
    assert_match "DONE 1 tests", output

    assert_match version.to_s, shell_output("#{bin}/gotestsum --version")
  end
end
