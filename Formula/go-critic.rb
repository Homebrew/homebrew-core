class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https://go-critic.com"
  url "https://github.com/go-critic/go-critic/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "75248d8a909e8655040b3af778d92b27beca271dcc210e546607abecc9589d09"
  license "MIT"
  revision 1
  head "https://github.com/go-critic/go-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e409afca2bdc940c7ea610d6887bc4f4ef0567a472247408223a12442d7003cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f598789a3c77f1d1bf29a8b9e1d537bbd0e50fb3e8dc0c67e4826e8cdd1d931e"
    sha256 cellar: :any_skip_relocation, monterey:       "1faf958e9f80cd7e201a86998f6e90120f34d9cb84f0b8c48628301b1d0921cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d19b11c728b131bbcaf62f05dcb03e9a2775a556a5d52d4f1275a76352bc7e0"
    sha256 cellar: :any_skip_relocation, catalina:       "c8f9abad4d5185472f6e5dbf64ee8517c9722e228076ab7c1d474ee32e043e97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8768f6535c24f8a25553846fe6a4e05153c839020c27e835af3a26a8babc59bb"
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
