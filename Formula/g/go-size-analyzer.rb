class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https://github.com/Zxilly/go-size-analyzer"
  url "https://github.com/Zxilly/go-size-analyzer/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "aa8f5f14a68ab45a24623640e1e2be957594a933483af7a4e66e46f7caedeed0"
  license "AGPL-3.0-only"
  head "https://github.com/Zxilly/go-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab7c394186a92f7fb8b2abd1e7881bbf46bd9b7037e4a4e764e793b3df3e3be1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04f57f631532355ef149f313d17c0eaf8cdc9c76370ca579186c6a4411b900ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d53507f5022655545f57d0ac91cbd3bd0cee652dd275b70013670fb4e2b10a2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a9b38161519c290b180cdd66da4c5fe294d367697a58dbae6091adb319d7285"
    sha256 cellar: :any_skip_relocation, ventura:        "031746e2d0815e4031fe649d4415fe218b08ce111fe85dd9b8b901aae0df239d"
    sha256 cellar: :any_skip_relocation, monterey:       "bf39ce060de1b514e4f142d88ed06df37c600587a49d8c970a7a736220be1a78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50431ab030341810d88825b3ba1bd6f56666a4d26766cf9eec464acd0f3b5364"
  end

  depends_on "go" => [:build, :test]
  depends_on "node" => :build
  depends_on "pnpm" => :build

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
    assert_includes shell_output("#{bin}/gsa --version"), version

    assert_includes shell_output("#{bin}/gsa invalid", 1), "Usage"

    (testpath/"hello.go").write <<~EOS
      package main

      import "fmt"

      func main() {
        fmt.Println("Hello, World")
      }
    EOS

    system "go", "build", "-o", testpath/"hello", testpath/"hello.go"

    output = shell_output("#{bin}/gsa #{testpath}/hello 2>&1")

    assert_includes output, "runtime"
    assert_includes output, "main"
  end
end
