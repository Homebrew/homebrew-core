class Gotestsum < Formula
  desc "Human friendly `go test` runner"
  homepage "https://github.com/gotestyourself/gotestsum"
  url "https://github.com/gotestyourself/gotestsum/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "e64d58e1bf4f4c4b82b3a703ed5046ea2b4eb827d2a7ba2ead3216bb5fb85547"
  license "Apache-2.0"
  head "https://github.com/gotestyourself/gotestsum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14e0a77f3a209ac4a89f01392dfe1287abd44e0feff5a074836a245c93175ce4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14e0a77f3a209ac4a89f01392dfe1287abd44e0feff5a074836a245c93175ce4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14e0a77f3a209ac4a89f01392dfe1287abd44e0feff5a074836a245c93175ce4"
    sha256 cellar: :any_skip_relocation, sonoma:        "56fbdac1bdbbd18d6bd1143d82682005c595e1853145b7bd719c3eb3ebbaf43a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a024bf29449f29cd313c0ef7beb3278d9fb1348c6f863cd08cd83c397cabe78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34e682e9cd93f3236142e4a9aafd45acb16b83fd069afeebeabf23b32e5a4243"
  end

  depends_on "go" => [:build, :test]

  # Workaround to inject version as ldflags
  # PR ref: https://github.com/gotestyourself/gotestsum/pull/528
  patch do
    url "https://github.com/gotestyourself/gotestsum/commit/47842dbc0c69364e0bacb61cc1ac4fce5ed2b6c5.patch?full_index=1"
    sha256 "ed666978dac6b6757b1e71978d8f2bf9726aee5939ebca0d3837efd3073f718c"
  end

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
