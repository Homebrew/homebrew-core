class Gotestsum < Formula
  desc "Human friendly `go test` runner"
  homepage "https://github.com/gotestyourself/gotestsum"
  url "https://github.com/gotestyourself/gotestsum/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "6537b03b185e55bb29da7eae9b3aa257bad97d3660ca37bf6b8e1cae5324bc2b"
  license "Apache-2.0"
  head "https://github.com/gotestyourself/gotestsum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbdf7a8635af342e9b88eef20356de2802c900b8fe3492c53a6189e444d315b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbdf7a8635af342e9b88eef20356de2802c900b8fe3492c53a6189e444d315b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dbdf7a8635af342e9b88eef20356de2802c900b8fe3492c53a6189e444d315b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "62fab5469ef63bb0d107be8cf90fbb4388c1dd731776fafb333c699f374954d3"
    sha256 cellar: :any_skip_relocation, ventura:       "62fab5469ef63bb0d107be8cf90fbb4388c1dd731776fafb333c699f374954d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9acf461a7e12a69a721bde63dd127334d49bd0f397b9f23319d2d27edabf4de"
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
