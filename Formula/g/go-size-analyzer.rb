class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https://github.com/Zxilly/go-size-analyzer"
  url "https://github.com/Zxilly/go-size-analyzer/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "7b8aed4a7d5e6e9da723f91e70fc0532655854cc5975fa5d04e7a6166900b659"
  license "AGPL-3.0-only"
  head "https://github.com/Zxilly/go-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc508ebd751377f9d5c4e1091c71e94c54d8cb039d928997c89629c16c172254"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baaf494823b818261a9199f8191078cd80275dbb6acc10cbfeb0d139e86be551"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af4125e1cfe04f8233ab6b0334ceb5947bbd8016796002ce5c139220ccb13d6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fa8775254854545d2f556e41bd0ad219d0470b496fb0825258d9076b990e04d"
    sha256 cellar: :any_skip_relocation, ventura:       "5d5391fd811aaf2aa027b90eb8c82535e06e16c4c63d0a5f05ecd54088d5f80e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46463414b4fc88e129e710850822e560550b82b27075b81447d9ba89211a8d3c"
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

    (testpath/"hello.go").write <<~GO
      package main

      func main() {
        println("Hello, World")
      }
    GO

    system "go", "build", testpath/"hello.go"

    output = shell_output("#{bin}/gsa #{testpath}/hello 2>&1")
    assert_match "runtime", output
    assert_match "main", output
  end
end
