class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https://github.com/Zxilly/go-size-analyzer"
  url "https://github.com/Zxilly/go-size-analyzer/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "d5276c378d58f11f34bde4b12ec6fd1a9b9e9a22374abcb80b58eeff6e9c539b"
  license "AGPL-3.0-only"
  head "https://github.com/Zxilly/go-size-analyzer.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75244bc0bdddab0344658695825f387d21e2ee409b0ea25b5f7dcd27da9f324e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "345b29acb158ce911270583f72a6edbb3aac9871087308b1349f07e5b7e2ea6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a936db277ffc6dcb30cdc02cd1452224e755e9fa723b6b72d1cfcee47305f67"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a4d2a983340a6e6f3da84fc50613be699653a65c52d8a7a50d62f933a957686"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68056c7d54ff9d58a5b299f00bd69b1719f37162135c82948734986e80da987f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "759547c4fa20e347784a7cdb03d618decd515e6da3bb6978cc1ebfcb4a81eab0"
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
