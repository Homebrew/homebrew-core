class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https://go-critic.com"
  url "https://github.com/go-critic/go-critic/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "51890835e3811ab27f3dd7f9dc3bab140de774c3ce438d51944209ad2c4291f1"
  license "MIT"
  head "https://github.com/go-critic/go-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee582e16c0a1050447b3778ea9102a43f984733e5366a7401e2dce7a140205f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee582e16c0a1050447b3778ea9102a43f984733e5366a7401e2dce7a140205f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee582e16c0a1050447b3778ea9102a43f984733e5366a7401e2dce7a140205f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7a628851b80e5cd3c6438aaff8ae43fb797f3db50af9e76f73e4ae391ebd583"
    sha256 cellar: :any_skip_relocation, ventura:        "e7a628851b80e5cd3c6438aaff8ae43fb797f3db50af9e76f73e4ae391ebd583"
    sha256 cellar: :any_skip_relocation, monterey:       "e7a628851b80e5cd3c6438aaff8ae43fb797f3db50af9e76f73e4ae391ebd583"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cb2c6210fb7717b6c8b4792679fc18c2a912f6f48f7639f69adb1232479e811"
  end

  depends_on "go"

  def install
    ldflags = "-s -w"
    ldflags += " -X main.Version=v#{version}" unless build.head?
    system "go", "build", *std_go_args(ldflags:, output: bin/"gocritic"), "./cmd/gocritic"
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
