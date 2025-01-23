class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https://github.com/Zxilly/go-size-analyzer"
  url "https://github.com/Zxilly/go-size-analyzer/archive/refs/tags/v1.7.6.tar.gz"
  sha256 "87bbf2a09afc9ebc93294826bd5410656fb96ae9f749078c0a322c181b3de61e"
  license "AGPL-3.0-only"
  head "https://github.com/Zxilly/go-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e80bb4a58d84b38d8cddfee01fcbe43f823dfe35af5fc5cf40f1fae03a156494"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "282a802a1ed72ed4ab2cb2257b7e0b41642ef858dcd251663afdb1d9915a3b3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81684e94c55a31a7afd6ae75265369ab9f630865594c9024e962cdf07ac2e8ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "52db5d3fb9fa96b40e06306934665f3077c05bd8479fd1b7d5b30c06728b284c"
    sha256 cellar: :any_skip_relocation, ventura:       "ce6c093e90567e32a7695bdec4b29330bc43dcbd71550c5fdeedceb13432ce35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4593b0996f6bf3cecaa6558ec2d72e07f80648ed8af66266aaebd88f9183749b"
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
