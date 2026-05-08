class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https://github.com/Zxilly/go-size-analyzer"
  url "https://github.com/Zxilly/go-size-analyzer/archive/refs/tags/v1.12.6.tar.gz"
  sha256 "269add0f001bc670974c913968a9f2f68f5966a7afadce7027c0b75c3627f28b"
  license "AGPL-3.0-only"
  head "https://github.com/Zxilly/go-size-analyzer.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d8bbbbb840bcce8f3ccee6e37542af9085ab07be967200ef4f6a0e4abbe5dc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ed8d00c701abaf1ac48f3fb725f777b60e107966ff5fa196314e32849dc8e87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53b56201393a85cfad89a06ec14619a2b808ce75b1df814632be24a20a66056c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2b2c6c44827e80e539ff0a151bbdfa2c58e75c55f2b4d3a3395462de74845bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5546677e9d5ba7595f02e0a9b7cd05403cef9b259f7c366d9a18f0108e99c5f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bd3270a56624d8c838810ebaa436afb6047ddc666f0f2937c2ff126340a2b53"
  end

  depends_on "go" => [:build, :test]
  depends_on "node" => :build
  depends_on "pnpm" => :build

  conflicts_with "gwenhywfar", because: "both install `gsa` binaries"

  def install
    system "pnpm", "--dir", "ui", "install"
    system "pnpm", "--dir", "ui", "build:ui"

    mv "ui/dist/webui/index.html", "internal/webui/index.html"

    # Set experimental feature for go
    ENV["GOEXPERIMENT"] = "jsonv2"

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
