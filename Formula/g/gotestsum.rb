class Gotestsum < Formula
  desc "Human friendly `go test` runner"
  homepage "https://github.com/gotestyourself/gotestsum"
  url "https://github.com/gotestyourself/gotestsum/archive/refs/tags/v1.12.3.tar.gz"
  sha256 "a78487894e411d8c96980b99201f165ba82281b5c20f10762638e0e6b5a75938"
  license "Apache-2.0"
  head "https://github.com/gotestyourself/gotestsum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d63c403ac8afa10f24baea91aba258d50d64651d4284ab38c60f8911737b5711"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d63c403ac8afa10f24baea91aba258d50d64651d4284ab38c60f8911737b5711"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d63c403ac8afa10f24baea91aba258d50d64651d4284ab38c60f8911737b5711"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a11858688db5857259f4b706a90e6687866424c9f8a38a0b21243fc08072378"
    sha256 cellar: :any_skip_relocation, ventura:       "4a11858688db5857259f4b706a90e6687866424c9f8a38a0b21243fc08072378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "138609040a3f0f13ee397a556134ef4193c3fe32b843b8c84e4e0b41c3aa98fb"
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
