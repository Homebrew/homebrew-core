class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https://github.com/Zxilly/go-size-analyzer"
  url "https://github.com/Zxilly/go-size-analyzer/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "0a70b079226d8d313d9c3d97eaaaebbc8d6eccfb2654b6d06730258c0799974c"
  license "AGPL-3.0-only"
  head "https://github.com/Zxilly/go-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb91216505dc09edd267a81e13645ec02e973c892d1fbe8ea00e29ecbdbff342"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f137f925147e907ed4bc9e860b43d64ce976727dd0ca007f43c0b299255fdfa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db6851e043fca3f29560dd166825ae1cb1c165f4fc13baca55301f9d8577f653"
    sha256 cellar: :any_skip_relocation, sonoma:        "595e5aa6aae69e91964b0c3922ed3df3038e3ad280ff64766a8ffe21176a3403"
    sha256 cellar: :any_skip_relocation, ventura:       "7012f45f92850e289b9fdcd824da9241c6d799e8e6838dcff1ef502ac5188db6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b43ad50fd4639c2e9f943257716350f0b69c204fb145bc2466ba4a99ec6256b6"
  end

  depends_on "go" => [:build, :test]
  depends_on "node" => :build
  depends_on "pnpm" => :build

  conflicts_with "gwenhywfar", because: "both install `gsa` binaries"

  def install
    system "pnpm", "--dir", "ui", "install"
    system "pnpm", "--dir", "ui", "build:ui"

    mv "ui/dist/webui/index.html", "internal/webui/index.html"

    ldflags = %W[
      -s -w
      -X github.com/Zxilly/go-size-analyzer.version=#{version}
      -X github.com/Zxilly/go-size-analyzer.buildDate=#{Time.now.iso8601}
      -X github.com/Zxilly/go-size-analyzer.dirtyBuild=false
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"gsa"), "-tags", "embed", "./cmd/gsa"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gsa --version")
    assert_match "Usage", shell_output("#{bin}/gsa invalid 2>&1", 1)

    (testpath/"hello.go").write <<~EOS
      package main

      import "fmt"

      func main() {
        fmt.Println("Hello, World")
      }
    EOS

    system "go", "build", testpath/"hello.go"

    output = shell_output("#{bin}/gsa #{testpath}/hello 2>&1")
    assert_match "runtime", output
    assert_match "main", output
  end
end
