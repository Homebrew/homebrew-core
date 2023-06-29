class Gotestsum < Formula
  desc "Human friendly `go test` runner"
  homepage "https://github.com/gotestyourself/gotestsum"
  url "https://github.com/gotestyourself/gotestsum/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "6c84141464b1927ea32098a13b6e470921c5a3fe7d5b62e54be643a941f83c1a"
  license "Apache-2.0"
  head "https://github.com/gotestyourself/gotestsum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a6a4cb17ec45fdea949a8fbd9f0338544e05ad469a95a5bfb4b99131ec14008"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a6a4cb17ec45fdea949a8fbd9f0338544e05ad469a95a5bfb4b99131ec14008"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a6a4cb17ec45fdea949a8fbd9f0338544e05ad469a95a5bfb4b99131ec14008"
    sha256 cellar: :any_skip_relocation, ventura:        "24a8b945a17c8831987390b15e84b5de1b00e966ca947d7429bbbcf8ff666672"
    sha256 cellar: :any_skip_relocation, monterey:       "24a8b945a17c8831987390b15e84b5de1b00e966ca947d7429bbbcf8ff666672"
    sha256 cellar: :any_skip_relocation, big_sur:        "24a8b945a17c8831987390b15e84b5de1b00e966ca947d7429bbbcf8ff666672"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aba097e6dbaaeb528de7c5595eef00766373d4c478d88fb41f1701de34074653"
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
