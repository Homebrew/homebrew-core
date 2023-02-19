class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https://go-critic.com"
  url "https://github.com/go-critic/go-critic/archive/refs/tags/v0.6.7.tar.gz"
  sha256 "f97572991de7c4a3c2aec7b32c6b73dd3b423d964d33c3102b65b5086b47bca5"
  license "MIT"
  head "https://github.com/go-critic/go-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29e13bd951250ab14d490a62f8970e9664c5c1112bc724e247b5a6c165b4f7cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f9f0dacb60956e2f933a5b53850978c07ae9670204a7d6c8c3f3f5597c32747"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25860c69d616771d8c998bda34e2397939836540eeb5d1715ec12389c3598310"
    sha256 cellar: :any_skip_relocation, ventura:        "6a049d252a7404074c4f46453d63fd38fff84834f0757eca8af047b5940f1f34"
    sha256 cellar: :any_skip_relocation, monterey:       "cc628308f7d43ef410e55d47ed07c218d9b2ef5ef1d0671736730e90f2f2c44f"
    sha256 cellar: :any_skip_relocation, big_sur:        "284ced76ce997a5b7df4e195b7ccf5c6d0e7c854e331e3139937b85be636d64f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88c85d0c2c2c7252c39c4c37d3977a94a4357e9a1171dd09de1f3ad2005b7149"
  end

  depends_on "go"

  def install
    ldflags = "-s -w"
    ldflags += " -X main.Version=v#{version}" unless build.head?
    system "go", "build", "-trimpath", "-ldflags", ldflags, "-o", bin/"gocritic", "./cmd/gocritic"
  end

  test do
    (testpath/"main.go").write <<~EOS
      package main

      import "fmt"

      func main() {
        str := "Homebrew"
        if len(str) <= 0 {
          fmt.Println("If you're reading this, something is wrong.")
        }
      }
    EOS

    output = shell_output("#{bin}/gocritic check main.go 2>&1", 1)
    assert_match "sloppyLen: len(str) <= 0 can be len(str) == 0", output
  end
end
