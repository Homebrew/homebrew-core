class Gotestsum < Formula
  desc "Human friendly `go test` runner"
  homepage "https://github.com/gotestyourself/gotestsum"
  url "https://github.com/gotestyourself/gotestsum/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "84e1f0f44c23d1af1ed97788f0f65a3a5836deb848d51b20a57ed914b0aed0bb"
  license "Apache-2.0"
  head "https://github.com/gotestyourself/gotestsum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4f4fade0e7e291c869b850cd321edf812e7ecfa85495aa8ae4c937ded52b24b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c46808ce583767f3827a701bd84c731b7f1160271a7b4f9b882aba14517c49b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "003b597593091a4b61a445066d5bfe52fcc3941c1e5e4e5ec15117f8bb983d30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36c5f912e8f2f16fa0a2cce4cd5b7ee1a4e484fea5da8ce16b40db80d47ff07e"
    sha256 cellar: :any_skip_relocation, sonoma:         "43212f54a3d4b5257e77e0ded25adaec94ae09b1c0a692103b51df75167f93bc"
    sha256 cellar: :any_skip_relocation, ventura:        "e79730ec658cff21b76f41ce61f3c7c40b6e1978c237ccc968a99dac4c836710"
    sha256 cellar: :any_skip_relocation, monterey:       "cc9333c0d2e048743d0d58bb64ed0efe704d6efe1ff1d94f40b21ce05ed33383"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c754755b429926b5eddacac0fa582188be1e959757584a6f90bc40c7d3cff7a4"
  end

  depends_on "go" => [:build, :test]

  def install
    ldflags = "-s -w -X gotest.tools/gotestsum/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
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
