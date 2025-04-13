class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https://github.com/Zxilly/go-size-analyzer"
  url "https://github.com/Zxilly/go-size-analyzer/archive/refs/tags/v1.7.9.tar.gz"
  sha256 "bde796586eecbc82abf9ecf2f07d8b19f823c001e26630610f38e98e9ba07064"
  license "AGPL-3.0-only"
  head "https://github.com/Zxilly/go-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e8cf99a0cae6773d28b929269350f58607bb3dbd844a5190a5a1c341948fafe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "299ae7074c91c4efaf52d00c42a31f0e964fe36a76c31213f0421a68a93283e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5f7799860bb2d47830137845719a72be50a6fa3a409b6f9369ca6ec62fb2b70"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b88e5cca265f246cc1ef280adbf75f51d4cd0b5d31e495a9c997698bc9fe66e"
    sha256 cellar: :any_skip_relocation, ventura:       "79ae5deba51658b0e085fc998916edeca70c30b3b7878567a5f5c90d9c1d5556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08c35bb05e2a5c1cb25c1dcf60fd698d0b316e7a067aea23e1884c9235354900"
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

    system "go", "build", *std_go_args(ldflags:, tags: "embed", output: bin/"gsa"), "./cmd/gsa"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gsa --version")
    assert_match "Usage", shell_output("#{bin}/gsa invalid 2>&1", 80)

    (testpath/"hello.go").write <<~GO
      package main

      import "fmt"

      func main() {
        fmt.Println("Hello, World")
      }
    GO

    system "go", "build", testpath/"hello.go"

    output = shell_output("#{bin}/gsa #{testpath}/hello 2>&1")
    assert_match "runtime", output
    assert_match "main", output
  end
end
