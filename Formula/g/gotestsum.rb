class Gotestsum < Formula
  desc "Human friendly `go test` runner"
  homepage "https://github.com/gotestyourself/gotestsum"
  url "https://github.com/gotestyourself/gotestsum/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "b75695eff12ed246e6720c8ccd283c42bd4d5fd41a897ac258ffa6eebf17d40a"
  license "Apache-2.0"
  head "https://github.com/gotestyourself/gotestsum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4de88d0c22f857e29c16f4829bc0cae7af84e310588ca0f4ae200596cb8fde96"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6cd55d7915617a642b0cd7380f7edd904b62743462998c236663d1ece0ba528"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c1a4a179d1e49f1895fb680f0f743144df07b899b5a307d5532bfd9f9a03b67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2b4c973e92041e74332671d1e60582221a246004650e8b9e462b79b216902ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "646effd83d60a06860d1c8b8796a8f27c309dae3943093d9321e8eec9387a85b"
    sha256 cellar: :any_skip_relocation, ventura:        "b09a5443f8595f98ea679b9fb32d958c968517aba9a28b8d77e44a8832244127"
    sha256 cellar: :any_skip_relocation, monterey:       "5414ba0d792706ca08fcdcb0f8b186b158aec28e99401ad442c1a9fd91fb7bee"
    sha256 cellar: :any_skip_relocation, big_sur:        "6466bb4c54e54b9fccf5b4019c00539cfe839577b6926e50363233d35ae222b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8147f38bd97e667a02006fbf4afab7236eda8962d9ba102c1a272486e39e2e0b"
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
