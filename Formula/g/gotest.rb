class Gotest < Formula
  desc "Like go test but with colors"
  homepage "https://github.com/rakyll/gotest"
  url "https://github.com/rakyll/gotest/archive/refs/tags/v0.0.6.tar.gz"
  sha256 "8d6e987c0124247268cec2537aa3ceff1a0f88bcdd155706e405de2903fd5167"
  license "BSD-3-Clause"
  head "https://github.com/rakyll/gotest.git", branch: "master"

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
        return "Hello, gotest."
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
        want := "Hello, gotest."
        if got != want {
          t.Errorf("got %q, want %q", got, want)
        }
      }
    EOS

    assert_match "ok  \tgithub.com/Homebrew/brew-test\t", shell_output("#{bin}/gotest ./...")
  end
end
